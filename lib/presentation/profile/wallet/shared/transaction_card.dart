import 'package:flutter/material.dart';

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
  final CreditTransactionModel transaction;
  final bool isCreditTab;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${transaction.createdAt.day.toString().padLeft(2, '0')}-${transaction.createdAt.month.toString().padLeft(2, '0')}-${transaction.createdAt.year}';

    final absoluteAmount = transaction.amount.abs();
    String amountStr;
    Color amountColor;

    if (isCreditTab) {
      final isDeduction = transaction.type == TransactionType.deduct;
      final sign = isDeduction ? '-' : '+';
      final val = absoluteAmount.toInt();
      amountStr = '$sign $val ${val <= 1 ? 'Credit' : 'Credits'}';
      amountColor = isDeduction ? ThemeColor.black : ThemeColor.green;
    } else {
      amountStr = '- RM ${absoluteAmount.toStringAsFixed(2)}';
      amountColor = ThemeColor.black;
    }

    final isPending = transaction.status == TransactionStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isPending
                  ? ThemeColor.orange.withValues(alpha: 0.5)
                  : ThemeColor.white,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.description,
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          decoration:
                              transaction.status == TransactionStatus.refunded
                                  ? TextDecoration.lineThrough
                                  : null,
                          color:
                              transaction.status == TransactionStatus.refunded
                                  ? ThemeColor.grey100
                                  : ThemeColor.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPending) ...[
                      8.widthBox,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColor.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PENDING',
                          style: AppWidget.bodyExtraSmall().copyWith(
                            color: ThemeColor.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                6.heightBox,
                Text(
                  dateStr,
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          16.widthBox,
          Text(
            amountStr,
            style: AppWidget.bodyLarge().copyWith(
              fontWeight: FontWeight.bold,
              color: isPending ? ThemeColor.grey100 : amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
