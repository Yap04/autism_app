import 'package:flutter/material.dart';
import 'color_constant.dart';

class BadgeDef {
  const BadgeDef({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.requiredPoints = 0,
  });
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final int requiredPoints;
}

class AppBadges {
  static const List<BadgeDef> allBadges = [
    BadgeDef(
      id: 'certified_pro',
      label: 'Certified\nPro',
      icon: Icons.verified,
      color: ThemeColor.blue,
      requiredPoints: 50,
    ),
    BadgeDef(
      id: 'first_aid',
      label: 'First Aid\nHero',
      icon: Icons.health_and_safety,
      color: ThemeColor.red,
      requiredPoints: 100,
    ),
    BadgeDef(
      id: 'autism_expert',
      label: 'Autism\nExpert',
      icon: Icons.diversity_1,
      color: ThemeColor.orange,
      requiredPoints: 200,
    ),
    BadgeDef(
      id: 'sign_language',
      label: 'Sign Lang\nBasic',
      icon: Icons.sign_language,
      color: ThemeColor.green,
      requiredPoints: 300,
    ),
    BadgeDef(
      id: 'sensory_play',
      label: 'Sensory\nPlay',
      icon: Icons.toys_rounded,
      color: Colors.purple,
      requiredPoints: 450,
    ),
    BadgeDef(
      id: 'child_psych',
      label: 'Child\nPsych',
      icon: Icons.psychology_rounded,
      color: Colors.teal,
      requiredPoints: 600,
    ),
    BadgeDef(
      id: 'master_coach',
      label: 'Master\nCoach',
      icon: Icons.workspace_premium_rounded,
      color: Colors.amber,
      requiredPoints: 1000,
    ),
  ];
}
