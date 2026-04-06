import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeColor.darkBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        child:
            isLoading
                ? const Center(
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: ThemeColor.white,
                      strokeWidth: 2.5,
                    ),
                  ),
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
