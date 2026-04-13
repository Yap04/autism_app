import 'package:flutter/material.dart';

import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';

class EmptyTransactionState extends StatelessWidget {
  const EmptyTransactionState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'No transaction history yet.',
          style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
        ),
      ),
    );
  }
}
