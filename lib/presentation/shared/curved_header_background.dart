import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';

class CurvedHeaderBackground extends StatelessWidget {
  const CurvedHeaderBackground({
    this.customHeight,
    this.isCurved = false,
    super.key,
  });

  final double? customHeight;
  final bool isCurved;

  @override
  Widget build(BuildContext context) {
    final height = customHeight ?? MediaQuery.of(context).padding.top + 130;

    if (!isCurved) {
      return Container(
        height: height,
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

    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: ThemeColor.backgroundAquaBlue,
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const curveDepth = 50;

    path
      ..lineTo(0, 0)
      ..lineTo(0, size.height - curveDepth)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height - curveDepth,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
