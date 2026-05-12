import 'package:flutter/widgets.dart';
import '../../domain/models/user_model.dart';
import 'localization_ext.dart';

extension GenderLocalizationExt on Gender {
  String toLocalized(BuildContext context) {
    return switch (this) {
      Gender.male => context.l10n.genderMale,
      Gender.female => context.l10n.genderFemale,
      Gender.other => context.l10n.genderOther,
    };
  }
}

extension GenderStringLocalizationExt on String {
  String toLocalized(BuildContext context) {
    return switch (toLowerCase()) {
      'male' => context.l10n.genderMale,
      'female' => context.l10n.genderFemale,
      'other' => context.l10n.genderOther,
      _ => this,
    };
  }
}
