import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../domain/models/user_model.dart';

class GenderDropdownField extends StatelessWidget {
  const GenderDropdownField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Gender? value;
  final ValueChanged<Gender?> onChanged;

  String _getGenderLabel(Gender gender) {
    switch (gender) {
      case Gender.female:
        return 'Female';
      case Gender.male:
        return 'Male';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Gender>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: ThemeColor.grey100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ThemeColor.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ThemeColor.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ThemeColor.orange),
        ),
        filled: true,
        fillColor: const Color(0xFFFFF9E6),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: ThemeColor.orange),
      items:
          Gender.values.map((Gender gender) {
            return DropdownMenuItem<Gender>(
              value: gender,
              child: Text(_getGenderLabel(gender)),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }
}
