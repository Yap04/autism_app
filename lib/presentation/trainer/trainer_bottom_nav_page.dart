import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../chat/chat_list_page.dart';
import '../profile/profile_page.dart';
import 'appointment/trainer_appointments_page.dart';
import 'home/trainer_home_page.dart';
import 'trainer_my_students_page.dart';

@RoutePage()
class TrainerBottomNavPage extends StatefulWidget {
  const TrainerBottomNavPage({super.key});

  @override
  State<TrainerBottomNavPage> createState() => _TrainerBottomNavPageState();
}

class _TrainerBottomNavPageState extends State<TrainerBottomNavPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TrainerHomePage(),
    ChatListPage(),
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
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_outlined),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Appointments',
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
