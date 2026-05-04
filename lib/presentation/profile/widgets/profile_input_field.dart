import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';

class ProfileInputField extends StatelessWidget {
  const ProfileInputField({
    required this.label,
    super.key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.prefixWidget,
    this.suffixWidget,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
  });

  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: readOnly ? Colors.grey.shade300 : ThemeColor.orange,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          if (prefixWidget != null) ...[prefixWidget!, 12.widthBox],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
                2.heightBox,
                TextFormField(
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  controller: controller,
                  initialValue: initialValue,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.w600,
                    color: readOnly ? Colors.grey.shade400 : ThemeColor.black,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          if (suffixWidget != null) ...[12.widthBox, suffixWidget!],
        ],
      ),
    );
  }
}
