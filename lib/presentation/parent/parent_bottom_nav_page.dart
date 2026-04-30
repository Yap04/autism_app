import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/appointment/appointment_notifier.dart';
import '../../application/appointment/appointment_provider.dart';
import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../domain/models/appointment_model.dart';
import '../chat/chat_list_page.dart';
import '../profile/profile_page.dart';
import 'appointment/parent_appointments_page.dart';
import 'appointment/parent_discover_page.dart';
import 'home/parent_home_page.dart';

@RoutePage()
class ParentBottomNavPage extends ConsumerStatefulWidget {
  const ParentBottomNavPage({super.key});

  @override
  ConsumerState<ParentBottomNavPage> createState() =>
      _ParentBottomNavPageState();
}

class _ParentBottomNavPageState extends ConsumerState<ParentBottomNavPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ParentHomePage(),
    ChatListPage(),
    ParentDiscoverPage(),
    ParentAppointmentsPage(),
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

    if (currentUser != null) {
      ref.listen<AsyncValue<List<AppointmentModel>>>(
        parentAppointmentsStreamProvider(currentUser.id),
        (previous, next) {
          if (previous != null && previous.hasValue && next.hasValue) {
            final prevList = previous.value!;
            final nextList = next.value!;

            for (final nextApp in nextList) {
              if (nextApp.status == AppointmentStatus.accepted) {
                final prevApp =
                    prevList.where((a) => a.id == nextApp.id).firstOrNull;

                if (prevApp != null &&
                    prevApp.status != AppointmentStatus.accepted) {
                  ref
                      .read(appointmentNotifierProvider.notifier)
                      .scheduleRemindersForAppointment(nextApp);
                }
              }
            }
          }
        },
      );
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
