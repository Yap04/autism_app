import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/app_text_field.dart';
import '../../shared/bottom_action_button.dart';

class BankDetailsBottomSheet extends StatefulWidget {
  const BankDetailsBottomSheet({super.key});

  @override
  State<BankDetailsBottomSheet> createState() => BankDetailsBottomSheetState();
}

class BankDetailsBottomSheetState extends State<BankDetailsBottomSheet> {
  final _bankNameController = TextEditingController();
  final _accNumberController = TextEditingController();
  final _holderNameController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accNumberController.dispose();
    _holderNameController.dispose();
    super.dispose();
  }

  void _checkValidity() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final isValid =
        _bankNameController.text.trim().isNotEmpty &&
        _accNumberController.text.trim().isNotEmpty &&
        _holderNameController.text.trim().isNotEmpty;

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
            Text(
              context.l10n.addBankDetails,
              style: AppWidget.h2TextFieldStyle(),
            ),
            8.heightBox,
            Text(
              context.l10n.provideBankDetailsDescription,
              style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
            ),
            24.heightBox,

            Text(
              context.l10n.bankNameLabel,
              style: AppWidget.bodySmall().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.heightBox,
            AppTextField(
              controller: _bankNameController,
              hintText: context.l10n.bankNameHint,
              onChanged: (_) => _checkValidity(),
              fillColor: ThemeColor.cream,
              borderRadius: 12,
              textColor: ThemeColor.grey100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            16.heightBox,

            Text(
              context.l10n.accountNumberLabel,
              style: AppWidget.bodySmall().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.heightBox,
            AppTextField(
              controller: _accNumberController,
              hintText: context.l10n.accountNumberHint,
              keyboardType: TextInputType.number,
              onChanged: (_) => _checkValidity(),
              fillColor: ThemeColor.cream,
              borderRadius: 12,
              textColor: ThemeColor.grey100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            16.heightBox,

            Text(
              context.l10n.accountHolderNameLabel,
              style: AppWidget.bodySmall().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.heightBox,
            AppTextField(
              controller: _holderNameController,
              hintText: context.l10n.accountHolderNameHint,
              keyboardType: TextInputType.number,
              onChanged: (_) => _checkValidity(),
              fillColor: ThemeColor.cream,
              borderRadius: 12,
              textColor: ThemeColor.grey100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            32.heightBox,

            BottomActionButton(
              label: context.l10n.saveDetailsAction,
              borderRadius: 16,
              textStyle: AppWidget.h3TextFieldStyle().copyWith(
                color: ThemeColor.white,
              ),
              onPressed:
                  isValid
                      ? () {
                        Navigator.pop(context, {
                          'bankName': _bankNameController.text.trim(),
                          'accountNumber': _accNumberController.text.trim(),
                          'holderName': _holderNameController.text.trim(),
                        });
                      }
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
