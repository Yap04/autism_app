import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/transaction_model.dart';
import '../../domain/models/user_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

class PaymentNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> buyCreditPackage({
    required UserModel currentUser,
    required int creditsToAdd,
    required String priceString,
    required String packageTitle,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final cleanPrice = priceString.replaceAll('RM ', '').trim();
      final amount = double.parse(cleanPrice);

      final isSuccess = await ref
          .read(stripeServiceProvider)
          .makePayment(amount: amount, currency: 'myr');

      if (isSuccess == null) {
        throw Exception('Payment was cancelled or failed.');
      }

      final currentCredits = currentUser.sessionCredits;
      final updatedUser = currentUser.copyWith(
        sessionCredits: currentCredits + creditsToAdd,
      );

      await ref.read(userRepositoryProvider).updateUser(updatedUser);

      final transactionRepo = ref.read(transactionRepositoryProvider);
      final now = DateTime.now();

      final stripeTransaction = TransactionModel(
        id: 'tx_stripe_${now.millisecondsSinceEpoch}',
        parentId: currentUser.id,
        type: TransactionType.payment,
        paymentChannel: PaymentChannel.stripe,
        amount: amount,
        description: 'Payment for $packageTitle',
        createdAt: now,
      );
      await transactionRepo.addTransaction(stripeTransaction);

      final creditTransaction = TransactionModel(
        id: 'tx_credit_${now.millisecondsSinceEpoch}',
        parentId: currentUser.id,
        type: TransactionType.topUp,
        paymentChannel: PaymentChannel.credit,
        amount: creditsToAdd.toDouble(),
        description: 'Received from $packageTitle',
        createdAt: now.add(const Duration(milliseconds: 100)),
      );

      await transactionRepo.addTransaction(creditTransaction);

      ref.invalidate(authNotifierProvider);
    });
  }
}

final paymentNotifierProvider = AsyncNotifierProvider<PaymentNotifier, void>(
  () {
    return PaymentNotifier();
  },
);

final userTransactionsStreamProvider =
    StreamProvider.family<List<TransactionModel>, String>((ref, userId) {
      return ref
          .watch(transactionRepositoryProvider)
          .getUserTransactions(userId);
    });
