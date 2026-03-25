import 'package:flutter/material.dart';
import '../../core/constant/color_constant.dart';

class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = ThemeColor.negative,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: ThemeColor.white, fontSize: 14),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(context, message, backgroundColor: ThemeColor.green);
  }

  static void error(BuildContext context, String message) {
    show(context, message);
  }

  static void info(BuildContext context, String message) {
    show(context, message, backgroundColor: ThemeColor.orange);
  }
}
