import 'package:flutter/material.dart';

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
