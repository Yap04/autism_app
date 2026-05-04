import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/user_model.dart';

class GenderSelectorField extends StatelessWidget {
  const GenderSelectorField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Gender? value;
  final ValueChanged<Gender?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENDER',
          style: AppWidget.bodyExtraSmall().copyWith(
            color: ThemeColor.grey100,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        8.heightBox,
        Row(
          children:
              Gender.values.map((gender) {
                final isSelected = value == gender;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: gender != Gender.values.last ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => onChanged(gender),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? ThemeColor.darkBlue.withValues(alpha: 0.08)
                                  : ThemeColor.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? ThemeColor.darkBlue
                                    : ThemeColor.lightGrey,
                            width: isSelected ? 1.5 : 0.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          gender.name[0].toUpperCase() +
                              gender.name.substring(1),
                          style: AppWidget.bodySmall().copyWith(
                            color:
                                isSelected
                                    ? ThemeColor.darkBlue
                                    : ThemeColor.grey100,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
