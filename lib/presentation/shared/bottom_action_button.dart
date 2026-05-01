import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = ThemeColor.darkBlue,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        onPressed == null ? ThemeColor.lightGrey : backgroundColor;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child:
            isLoading
                ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: ThemeColor.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ],
                )
                : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
