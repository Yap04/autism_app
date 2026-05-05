import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../domain/models/user_model.dart';
import '../profile/profile_page.dart';
import '../profile/trainer_verification_page.dart';
import 'academy/trainer_academy_page.dart';
import 'appointment/trainer_appointments_page.dart';
import 'home/trainer_home_page.dart';
import 'student/trainer_my_students_page.dart';

@RoutePage()
class TrainerBottomNavPage extends ConsumerStatefulWidget {
  const TrainerBottomNavPage({super.key});

  @override
  ConsumerState<TrainerBottomNavPage> createState() =>
      _TrainerBottomNavPageState();
}

class _TrainerBottomNavPageState extends ConsumerState<TrainerBottomNavPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TrainerHomePage(),
    TrainerAcademyPage(),
    TrainerMyStudentsPage(),
    TrainerAppointmentsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isPendingTrainer =
        currentUser.verificationStatus == VerificationStatus.pending;

    if (isPendingTrainer) {
      final hasSubmittedDocs =
          currentUser.certificateUrls != null &&
          currentUser.certificateUrls!.isNotEmpty;

      if (!hasSubmittedDocs) {
        return const Scaffold(body: TrainerVerificationPage());
      } else {
        return const Scaffold(body: TrainerAcademyPage());
      }
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ThemeColor.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Academy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_outlined),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
