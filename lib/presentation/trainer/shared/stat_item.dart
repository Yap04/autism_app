import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';

class StatItem extends StatelessWidget {
  const StatItem({required this.label, this.value, this.valueWidget, super.key})
    : assert(
        value != null || valueWidget != null,
        'You must provide either a value string or a valueWidget',
      );

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppWidget.bodySmall().copyWith(
            color: ThemeColor.grey100,
            height: 1.2,
          ),
        ),
        8.heightBox,
        Container(
          height: 56,
          alignment: Alignment.center,
          child:
              valueWidget ?? Text(value!, style: AppWidget.h1TextFieldStyle()),
        ),
      ],
    );
  }
}
