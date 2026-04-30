import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/admin/transaction/admin_transaction_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/transaction_model.dart';

@RoutePage()
class AdminTransactionsPage extends ConsumerWidget {
  const AdminTransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(allTransactionsStreamProvider);
    final currentFilter = ref.watch(transactionFilterProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Transactions', style: AppWidget.h2TextFieldStyle()),
          8.heightBox,
          Text(
            'Track all payments, top-ups, and credit deductions.',
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),

          32.heightBox,

          transactionsAsync.when(
            data: (transactions) {
              final filteredList =
                  transactions.where((tx) {
                    if (currentFilter == 'All') {
                      return true;
                    }
                    return tx.type.name.toLowerCase() ==
                        currentFilter.toLowerCase();
                  }).toList();

              return Column(
                children: [
                  _buildStatOverview(transactions),
                  32.heightBox,
                  _buildFilterTabs(ref, currentFilter),
                  24.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTableHeader(),
                        const Divider(height: 1),
                        if (filteredList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(48),
                            child: Text('No transactions found.'),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            separatorBuilder:
                                (context, index) => const Divider(height: 1),
                            itemBuilder:
                                (context, index) =>
                                    _buildTransactionRow(filteredList[index]),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading:
                () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(
                      color: ThemeColor.darkBlue,
                    ),
                  ),
                ),
            error:
                (err, stack) => Center(
                  child: Text(
                    'Failed to load transactions: $err',
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.red,
                    ),
                  ),
                ),
          ),
          48.heightBox,
        ],
      ),
    );
  }

  Widget _buildStatOverview(List<TransactionModel> txs) {
    final totalStripe = txs
        .where(
          (t) =>
              t.paymentChannel == PaymentChannel.stripe &&
              t.status == TransactionStatus.completed,
        )
        .fold<double>(0, (sum, t) => sum + t.amount.abs());

    final totalDeducted =
        txs
            .where(
              (t) =>
                  t.type == TransactionType.deduct &&
                  t.status == TransactionStatus.completed,
            )
            .length;

    final totalRefunded =
        txs.where((t) => t.type == TransactionType.refund).length;

    return Row(
      children: [
        _buildStatCard(
          'Total Revenue (RM)',
          'RM ${totalStripe.toStringAsFixed(2)}',
          Icons.payments_outlined,
          ThemeColor.green,
        ),
        24.widthBox,
        _buildStatCard(
          'Total Sessions Booked',
          '$totalDeducted',
          Icons.confirmation_number_outlined,
          ThemeColor.blue,
        ),
        24.widthBox,
        _buildStatCard(
          'Refunded Count',
          '$totalRefunded',
          Icons.replay_rounded,
          ThemeColor.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.03),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            20.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                Text(value, style: AppWidget.h3TextFieldStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(WidgetRef ref, String activeFilter) {
    final filters = ['All', 'topUp', 'payment', 'deduct', 'refund'];
    return Row(
      children:
          filters.map((f) {
            final isSelected = activeFilter == f;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap:
                    () => ref
                        .read(transactionFilterProvider.notifier)
                        .setFilter(f),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? ThemeColor.darkBlue : ThemeColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected
                              ? ThemeColor.darkBlue
                              : ThemeColor.lightGrey,
                    ),
                  ),
                  child: Text(
                    f.toUpperCase(),
                    style: AppWidget.bodySmall().copyWith(
                      color: isSelected ? ThemeColor.white : ThemeColor.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: ThemeColor.cream.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Date & Time', style: _headerStyle())),
          Expanded(flex: 3, child: Text('Description', style: _headerStyle())),
          Expanded(child: Text('Channel', style: _headerStyle())),
          Expanded(child: Text('Amount', style: _headerStyle())),
          Expanded(child: Text('Status', style: _headerStyle())),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => AppWidget.bodySmall().copyWith(
    fontWeight: FontWeight.bold,
    color: ThemeColor.grey100,
  );

  Widget _buildTransactionRow(TransactionModel tx) {
    final absoluteAmount = tx.amount.abs();
    final unit = tx.paymentChannel == PaymentChannel.stripe ? 'RM' : 'Credits';

    final isPositive =
        tx.type == TransactionType.topUp || tx.type == TransactionType.refund;
    final isOldRefundedLedger = tx.status == TransactionStatus.refunded;

    final sign = isPositive ? '+' : '-';
    final amountColor =
        isOldRefundedLedger
            ? ThemeColor.grey100
            : (isPositive ? ThemeColor.green : ThemeColor.red);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(tx.createdAt),
                  style: AppWidget.bodyLarge().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(tx.createdAt),
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'ID: ${tx.id}',
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              tx.paymentChannel.name.toUpperCase(),
              style: AppWidget.bodySmall(),
            ),
          ),
          Expanded(
            child: Text(
              '$sign ${absoluteAmount.toStringAsFixed(tx.paymentChannel == PaymentChannel.stripe ? 2 : 0)} $unit',
              style: AppWidget.bodyMedium().copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: _buildStatusTag(tx.status)),
        ],
      ),
    );
  }

  Widget _buildStatusTag(TransactionStatus status) {
    final color =
        status == TransactionStatus.completed
            ? ThemeColor.green
            : (status == TransactionStatus.refunded
                ? ThemeColor.orange
                : ThemeColor.blue);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
