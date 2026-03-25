import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';

class CurvedHeaderBackground extends StatelessWidget {
  const CurvedHeaderBackground({this.customHeight, super.key});

  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: customHeight ?? MediaQuery.of(context).padding.top + 130,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ThemeColor.backgroundAquaBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }
}
