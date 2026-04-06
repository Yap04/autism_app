import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../chat/chat_list_page.dart';
import 'appointment/parent_discover_page.dart';
import 'parent_appointments_page.dart';
import 'parent_home_page.dart';
import 'parent_profile_page.dart';

@RoutePage()
class ParentBottomNavPage extends StatefulWidget {
  const ParentBottomNavPage({super.key});

  @override
  State<ParentBottomNavPage> createState() => _ParentBottomNavPageState();
}

class _ParentBottomNavPageState extends State<ParentBottomNavPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ParentHomePage(),
    ChatListPage(),
    ParentDiscoverPage(),
    ParentAppointmentsPage(),
    ParentProfilePage(),
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
            icon: Icon(Icons.explore_outlined),
            label: 'Discover',
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
