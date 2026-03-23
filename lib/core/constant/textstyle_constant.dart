import 'package:flutter/material.dart';

import 'color_constant.dart';

class AppWidget {
  static TextStyle h1TextFieldStyle() {
    return const TextStyle(
      color: ThemeColor.black,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle h2TextFieldStyle() {
    return const TextStyle(
      color: ThemeColor.black,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle h3TextFieldStyle() {
    return const TextStyle(
      color: ThemeColor.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bodyLarge() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }

  static TextStyle bodyMedium() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }

  static TextStyle bodySmall() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
  }
}
