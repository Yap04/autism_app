import 'package:flutter/material.dart';

import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    super.key,
    this.label,
    this.labelStyle,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.iconColor = const Color(0xFFA0A0A0),
    this.fillColor = const Color(0xFFF0F0F0),
    this.textColor = const Color(0xFFA0A0A0),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 12,
    ),
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.inputFormatters,
    this.style,
    this.borderRadius = 10.0,
    this.prefixText,
    this.prefixStyle,
  });

  final TextEditingController controller;
  final String? label;
  final TextStyle? labelStyle;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color iconColor;
  final Color fillColor;
  final Color textColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final EdgeInsetsGeometry contentPadding;
  final int maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final List<dynamic>? inputFormatters;

  final TextStyle? style;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: labelStyle ?? AppWidget.bodyMedium()),
          8.heightBox,
        ],
        TextField(
          controller: controller,
          style: style,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          focusNode: focusNode,
          inputFormatters: inputFormatters?.cast(),
          decoration: InputDecoration(
            fillColor: fillColor,
            filled: true,
            contentPadding: contentPadding,
            hintText: hintText,
            hintStyle: AppWidget.bodyMedium().copyWith(color: textColor),
            prefixText: prefixText,
            prefixStyle: prefixStyle,
            prefixIcon:
                prefixIcon != null
                    ? IconTheme(
                      data: IconThemeData(color: iconColor),
                      child: prefixIcon!,
                    )
                    : null,
            suffixIcon:
                suffixIcon != null
                    ? GestureDetector(onTap: onSuffixIconTap, child: suffixIcon)
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
