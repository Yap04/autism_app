import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/payment/payment_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/transaction_model.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/loading_components.dart';
import '../../shared/snack_bar.dart';
import 'bank_details_bottom_sheet.dart';
import 'shared/transaction_card.dart';
import 'withdraw_bottom_sheet.dart';

@RoutePage()
class TrainerWalletPage extends ConsumerWidget {
  const TrainerWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Please login first')));
    }

    final totalBalance = currentUser.walletBalance ?? 0.0;

    final transactionsAsync = ref.watch(
      userTransactionsProvider(currentUser.id),
    );

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        centerTitle: true,
        title: Text('My Wallet', style: AppWidget.h2TextFieldStyle()),
      ),
      body: transactionsAsync.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: ThemeColor.darkBlue),
            ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (transactions) {
          final sortedList = List<TransactionModel>.from(transactions)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return RefreshIndicator(
            color: ThemeColor.darkBlue,
            onRefresh: () async {
              ref
                ..invalidate(authNotifierProvider)
                ..invalidate(userTransactionsProvider(currentUser.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(context, ref, currentUser, totalBalance),

                  32.heightBox,

                  Text(
                    'Recent Transactions',
                    style: AppWidget.h3TextFieldStyle(),
                  ),
                  16.heightBox,

                  if (transactions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ThemeColor.lightGrey),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: ThemeColor.lightGrey,
                          ),
                          8.heightBox,
                          Text(
                            'No transactions yet.',
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.grey100,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) => 12.heightBox,
                      itemBuilder: (context, index) {
                        final tx = sortedList[index];
                        return TransactionCard(
                          transaction: tx,
                          isCreditTab: false,
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
    double balance,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ThemeColor.darkBlue, Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.darkBlue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: ThemeColor.white,
                size: 20,
              ),
              8.widthBox,
              Text(
                'Available Balance',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          16.heightBox,
          Text(
            'RM ${balance.toStringAsFixed(2)}',
            style: AppWidget.h1TextFieldStyle().copyWith(
              color: ThemeColor.white,
            ),
          ),
          24.heightBox,
          GestureDetector(
            onTap: () => _handleWithdraw(context, ref, currentUser, balance),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ThemeColor.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Withdraw Funds',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.darkBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleWithdraw(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
    double currentBalance,
  ) async {
    if (currentBalance <= 0) {
      AppSnackBar.error(context, 'You have no balance to withdraw.');
      return;
    }

    final hasBankDetails =
        currentUser.bankName != null &&
        currentUser.bankName!.trim().isNotEmpty &&
        currentUser.bankAccountNumber != null &&
        currentUser.bankAccountNumber!.trim().isNotEmpty;

    var userToProcess = currentUser;

    if (!hasBankDetails) {
      final bankInfo = await showModalBottomSheet<Map<String, String>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const BankDetailsBottomSheet(),
      );

      if (bankInfo == null) {
        return;
      }

      try {
        userToProcess = currentUser.copyWith(
          bankName: bankInfo['bankName'],
          bankAccountNumber: bankInfo['accountNumber'],
          accountHolderName: bankInfo['holderName'],
        );
        await ref.read(userRepositoryProvider).updateUser(userToProcess);

        ref.invalidate(authNotifierProvider);

        closeLoading();

        if (context.mounted) {
          AppSnackBar.success(
            context,
            'Bank details saved! You can now proceed to withdraw funds.',
          );
        }
        return;
      } catch (e) {
        closeLoading();
        if (context.mounted) {
          AppSnackBar.error(context, 'Failed to save bank details: $e');
        }
        return;
      }
    }

    if (!context.mounted) {
      return;
    }

    final withdrawAmount = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawBottomSheet(maxBalance: currentBalance),
    );

    if (withdrawAmount == null || withdrawAmount <= 0) {
      return;
    }

    showLoading();

    try {
      final now = DateTime.now();

      final withdrawTx = TransactionModel(
        id: 'tx_wd_${now.millisecondsSinceEpoch}',
        parentId: userToProcess.id,
        type: TransactionType.withdrawal,
        paymentChannel: PaymentChannel.credit,
        amount: withdrawAmount,
        description: 'Withdrawal to Bank Account',
        status: TransactionStatus.pending,
        createdAt: now,
      );

      await ref.read(transactionRepositoryProvider).addTransaction(withdrawTx);

      final finalUser = currentUser.copyWith(
        walletBalance: (currentUser.walletBalance ?? 0) - withdrawAmount,
      );
      await ref.read(userRepositoryProvider).updateUser(finalUser);

      ref.invalidate(authNotifierProvider);

      closeLoading();

      if (context.mounted) {
        AppSnackBar.success(
          context,
          'Withdrawal request for RM ${withdrawAmount.toStringAsFixed(2)} submitted! Pending admin approval.',
        );
      }
    } catch (e) {
      closeLoading();
      if (context.mounted) {
        AppSnackBar.error(context, e.toString());
      }
    }
  }
}
