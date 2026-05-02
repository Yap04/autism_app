import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/bottom_action_button.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({super.key});

  @override
  State<FeedbackBottomSheet> createState() => FeedbackBottomSheetState();
}

class FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  double _focusLevel = 3;
  double _energyLevel = 3;
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final isRemarksValid = _remarksController.text.trim().isNotEmpty;

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
            Text('Session Feedback', style: AppWidget.h2TextFieldStyle()),
            8.heightBox,
            Text(
              'How did the student perform today?',
              style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
            ),
            24.heightBox,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Focus & Attention',
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_focusLevel.toInt()}/5',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.darkBlue,
                  ),
                ),
              ],
            ),
            Slider(
              value: _focusLevel,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: ThemeColor.darkBlue,
              inactiveColor: ThemeColor.lightGrey,
              onChanged: (val) => setState(() => _focusLevel = val),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Energy Level',
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_energyLevel.toInt()}/5',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.darkBlue,
                  ),
                ),
              ],
            ),
            Slider(
              value: _energyLevel,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: ThemeColor.darkBlue,
              inactiveColor: ThemeColor.lightGrey,
              onChanged: (val) => setState(() => _energyLevel = val),
            ),

            16.heightBox,

            Row(
              children: [
                Text(
                  'Trainer Remarks',
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.widthBox,
                Text(
                  '*',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            8.heightBox,
            TextField(
              controller: _remarksController,
              maxLines: 3,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Required: Any special observations today?',
                hintStyle: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
                filled: true,
                fillColor: ThemeColor.cream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            32.heightBox,

            BottomActionButton(
              label: 'Submit & Complete',
              backgroundColor: ThemeColor.green,
              onPressed:
                  isRemarksValid
                      ? () {
                        Navigator.pop(context, {
                          'focus': _focusLevel.toInt(),
                          'energy': _energyLevel.toInt(),
                          'remarks': _remarksController.text.trim(),
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
