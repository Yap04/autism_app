import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';

class AiAvatar extends StatelessWidget {
  const AiAvatar({super.key, this.radius = 26, this.imageUrl});
  final double radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          imageUrl ?? 'asset/image/chatbot.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
