import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/app_text_field.dart';
import '../../shared/bottom_action_button.dart';

class WithdrawBottomSheet extends StatefulWidget {
  const WithdrawBottomSheet({required this.maxBalance, super.key});
  final double maxBalance;

  @override
  State<WithdrawBottomSheet> createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<WithdrawBottomSheet> {
  final _amountController = TextEditingController();
  double _enteredAmount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final isValid = _enteredAmount > 0 && _enteredAmount <= widget.maxBalance;
    final isExceeding = _enteredAmount > widget.maxBalance;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeColor.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            24.heightBox,
            Text('Withdraw Funds', style: AppWidget.h2TextFieldStyle()),
            8.heightBox,
            Text(
              'Enter the amount you wish to transfer to your bank account.',
              style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
            ),
            24.heightBox,

            AppTextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              fillColor: ThemeColor.cream,
              borderRadius: 16,
              style: AppWidget.h1TextFieldStyle().copyWith(
                color: isExceeding ? ThemeColor.red : ThemeColor.darkBlue,
              ),
              prefixText: 'RM ',
              prefixStyle: AppWidget.h2TextFieldStyle().copyWith(
                color: ThemeColor.grey100,
              ),
              onChanged: (val) {
                setState(() {
                  _enteredAmount = double.tryParse(val) ?? 0.0;
                });
              },
            ),

            12.heightBox,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available: RM ${widget.maxBalance.toStringAsFixed(2)}',
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                if (isExceeding)
                  Text(
                    'Insufficient balance',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),

            32.heightBox,

            BottomActionButton(
              label: 'Submit Request',
              borderRadius: 16,
              textStyle: AppWidget.h3TextFieldStyle().copyWith(
                color: ThemeColor.white,
              ),
              onPressed:
                  isValid ? () => Navigator.pop(context, _enteredAmount) : null,
            ),
          ],
        ),
      ),
    );
  }
}
