import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/transaction_model.dart';
import '../../domain/models/user_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'payment_notifier.g.dart';

@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> buyCreditPackage({
    required UserModel currentUser,
    required int creditsToAdd,
    required String priceString,
    required String packageTitle,
  }) async {
    state = const AsyncValue.loading();

    try {
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
    } catch (err, stack) {
      state = AsyncError(err, stack);
      rethrow;
    }
  }
}
