import 'package:flutter/widgets.dart';

import '../constant/weekdays_constant.dart';
import 'localization_ext.dart';

extension WeekdayLocalization on String {
  String localized(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      Weekdays.monday => l10n.weekdayMonday,
      Weekdays.tuesday => l10n.weekdayTuesday,
      Weekdays.wednesday => l10n.weekdayWednesday,
      Weekdays.thursday => l10n.weekdayThursday,
      Weekdays.friday => l10n.weekdayFriday,
      Weekdays.saturday => l10n.weekdaySaturday,
      Weekdays.sunday => l10n.weekdaySunday,
      _ => this,
    };
  }
}
