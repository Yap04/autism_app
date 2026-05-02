import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';
import '../../../../core/extension/widget_ext.dart';
import '../../../../domain/models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.transaction,
    required this.isCreditTab,
    super.key,
  });

  final TransactionModel transaction;
  final bool isCreditTab;

  @override
  Widget build(BuildContext context) {
    final isIncome =
        transaction.type == TransactionType.topUp ||
        transaction.type == TransactionType.refund ||
        transaction.type == TransactionType.earning;

    final amountPrefix = isIncome ? '+' : '-';
    final iconColor = isIncome ? ThemeColor.green : ThemeColor.orange;

    IconData txIcon;
    if (transaction.type == TransactionType.earning) {
      txIcon = Icons.monetization_on_outlined;
    } else if (transaction.type == TransactionType.withdrawal) {
      txIcon = Icons.account_balance_outlined;
    } else if (transaction.type == TransactionType.topUp) {
      txIcon = Icons.arrow_downward;
    } else if (transaction.type == TransactionType.deduct ||
        transaction.type == TransactionType.payment) {
      txIcon = Icons.arrow_upward;
    } else {
      txIcon = Icons.sync;
    }

    final dateFormat = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(transaction.createdAt);

    final absoluteAmount = transaction.amount.abs();
    String amountStr;
    if (isCreditTab) {
      final val = absoluteAmount.toInt();
      amountStr = '$amountPrefix $val Credit';
    } else {
      amountStr = '$amountPrefix RM ${absoluteAmount.toStringAsFixed(2)}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(txIcon, color: iconColor, size: 20),
          ),
          16.widthBox,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.black,
                    decoration:
                        transaction.status == TransactionStatus.refunded
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                4.heightBox,
                Text(
                  dateFormat,
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),

          8.widthBox,

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountStr,
                style: AppWidget.bodyLarge().copyWith(
                  color: ThemeColor.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transaction.status != TransactionStatus.completed) ...[
                4.heightBox,
                Text(
                  transaction.status.name.toUpperCase(),
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: ThemeColor.grey100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
