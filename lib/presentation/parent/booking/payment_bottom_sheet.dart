import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/appointment_model.dart';
import '../../shared/bottom_action_button.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({
    required this.totalPrice,
    required this.singleSessionBaseFee,
    required this.durationMinutes,
    required this.weeks,
    required this.remoteDiscountTotal,
    required this.requiredCredits,
    required this.availableCredits,
    required this.hasEnoughCredits,
    required this.initialPaymentMethod,
    required this.onConfirm,
    this.transportFee = 0.0,
    this.isHomeBased = false,
    super.key,
  });

  final double totalPrice;
  final double singleSessionBaseFee;
  final int durationMinutes;
  final int weeks;
  final double remoteDiscountTotal;

  final int requiredCredits;
  final int availableCredits;
  final bool hasEnoughCredits;
  final PaymentMethod initialPaymentMethod;
  final double transportFee;
  final bool isHomeBased;
  final void Function(PaymentMethod method) onConfirm;

  static Future<void> show({
    required BuildContext context,
    required double totalPrice,
    required double singleSessionBaseFee,
    required int durationMinutes,
    required int weeks,
    required double remoteDiscountTotal,
    required int requiredCredits,
    required int availableCredits,
    required bool hasEnoughCredits,
    required PaymentMethod initialPaymentMethod,
    required void Function(PaymentMethod method) onConfirm,
    double transportFee = 0.0,
    bool isHomeBased = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => PaymentBottomSheet(
            totalPrice: totalPrice,
            singleSessionBaseFee: singleSessionBaseFee,
            durationMinutes: durationMinutes,
            weeks: weeks,
            remoteDiscountTotal: remoteDiscountTotal,
            requiredCredits: requiredCredits,
            availableCredits: availableCredits,
            hasEnoughCredits: hasEnoughCredits,
            initialPaymentMethod: initialPaymentMethod,
            transportFee: transportFee,
            isHomeBased: isHomeBased,
            onConfirm: onConfirm,
          ),
    );
  }

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  late PaymentMethod _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialPaymentMethod;
  }

  double get _grandTotal => widget.totalPrice + widget.transportFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeColor.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: ThemeColor.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            context.l10n.paymentSummaryTitle,
            style: AppWidget.h3TextFieldStyle(),
          ),
          20.heightBox,

          _buildPriceRow(
            context.l10n.sessionFeeLabel,
            context.l10n.rmPriceFormat(
              widget.singleSessionBaseFee.toStringAsFixed(2),
            ),
          ),
          8.heightBox,

          _buildPriceRow(
            'Duration',
            '${widget.durationMinutes} mins',
          ),
          8.heightBox,

          _buildPriceRow(
            'Repeats',
            'x ${widget.weeks} Weeks',
          ),

          if (widget.remoteDiscountTotal > 0) ...[
            8.heightBox,
            _buildPriceRow(
              'Remote Discount',
              '- ${context.l10n.rmPriceFormat(widget.remoteDiscountTotal.toStringAsFixed(2))}',
              valueColor: ThemeColor.green,
            ),
          ],

          if (widget.transportFee > 0) ...[
            8.heightBox,
            _buildPriceRow(
              context.l10n.transportFeeLabel,
              context.l10n.rmPriceFormat(
                widget.transportFee.toStringAsFixed(2),
              ),
            ),
          ],

          16.heightBox,
          const Divider(color: ThemeColor.lightGrey),
          12.heightBox,

          _buildPriceRow(
            context.l10n.totalLabel,
            context.l10n.rmPriceFormat(_grandTotal.toStringAsFixed(2)),
            isBold: true,
          ),

          24.heightBox,

          Text(
            context.l10n.paymentMethodTitle,
            style: AppWidget.h3TextFieldStyle(),
          ),
          16.heightBox,

          _buildPaymentOption(
            method: PaymentMethod.credit,
            title: context.l10n.useSessionCreditTitle,
            subtitle:
                widget.isHomeBased
                    ? context.l10n.unavailableForHomeBased
                    : (widget.hasEnoughCredits
                        ? context.l10n.creditBalanceAndRequired(
                          widget.availableCredits.toString(),
                          widget.requiredCredits.toString(),
                        )
                        : context.l10n.notEnoughCredits(
                          widget.requiredCredits.toString(),
                          widget.availableCredits.toString(),
                        )),
            isDisabled: !widget.hasEnoughCredits || widget.isHomeBased,
          ),

          12.heightBox,

          _buildPaymentOption(
            method: PaymentMethod.singlePay,
            title: context.l10n.payPerSessionTitle,
            subtitle: context.l10n.totalPriceFormat(
              _grandTotal.toStringAsFixed(2),
            ),
            isDisabled: false,
          ),

          28.heightBox,

          BottomActionButton(
            label:
                _selectedMethod == PaymentMethod.credit
                    ? context.l10n.confirmAndDeductCredits(
                      widget.requiredCredits.toString(),
                    )
                    : context.l10n.proceedToPay(_grandTotal.toStringAsFixed(2)),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onConfirm(_selectedMethod);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppWidget.bodyMedium().copyWith(
            color: isBold ? ThemeColor.black : ThemeColor.grey100,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppWidget.bodyMedium().copyWith(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required bool isDisabled,
  }) {
    final isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedMethod = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? ThemeColor.grey100.withValues(alpha: 0.1)
                  : ThemeColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ThemeColor.darkBlue : ThemeColor.lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  isDisabled
                      ? ThemeColor.grey100
                      : (isSelected
                          ? ThemeColor.darkBlue
                          : ThemeColor.lightGrey),
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppWidget.bodyLarge().copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDisabled ? ThemeColor.grey100 : ThemeColor.black,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    subtitle,
                    style: AppWidget.bodySmall().copyWith(
                      color:
                          isDisabled
                              ? ThemeColor.grey100
                              : (isSelected
                                  ? ThemeColor.darkBlue
                                  : ThemeColor.grey100),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
