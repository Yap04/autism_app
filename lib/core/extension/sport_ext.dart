import 'package:flutter/material.dart';

import 'localization_ext.dart';

IconData getSportIcon(String sport) {
  final lowerSport = sport.toLowerCase();
  if (lowerSport.contains('swim')) return Icons.pool;
  if (lowerSport.contains('football')) return Icons.sports_soccer;
  if (lowerSport.contains('basket')) return Icons.sports_basketball;
  if (lowerSport.contains('tennis')) return Icons.sports_tennis;
  if (lowerSport.contains('gymnastics')) return Icons.accessibility_new;
  if (lowerSport.contains('yoga')) return Icons.self_improvement;
  if (lowerSport.contains('martial')) return Icons.sports_martial_arts;
  if (lowerSport.contains('badminton')) return Icons.sports_tennis;
  return Icons.sports;
}

extension SportLocalizationExt on String {
  String toLocalizedSport(BuildContext context) {
    switch (this) {
      case 'All':
        return context.l10n.sportAll;
      case 'Swimming':
        return context.l10n.sportSwimming;
      case 'Football':
        return context.l10n.sportFootball;
      case 'Basketball':
        return context.l10n.sportBasketball;
      case 'Tennis':
        return context.l10n.sportTennis;
      case 'Gymnastics':
        return context.l10n.sportGymnastics;
      case 'Yoga':
        return context.l10n.sportYoga;
      case 'Athletics':
        return context.l10n.sportAthletics;
      case 'Badminton':
        return context.l10n.sportBadminton;
      default:
        return this;
    }
  }
}
