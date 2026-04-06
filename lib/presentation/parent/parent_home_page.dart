import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/appointment/appointment_notifier.dart';
import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/appointment_model.dart';
import '../shared/curved_header_background.dart';

class ParentHomePage extends ConsumerStatefulWidget {
  const ParentHomePage({super.key});

  @override
  ConsumerState<ParentHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<ParentHomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState.value;

    final appointmentsAsync = ref.watch(appointmentNotifierProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 180,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning, \n${currentUser?.name ?? 'User'}!',
                          style: AppWidget.h2TextFieldStyle(),
                        ),
                        const Spacer(),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: ThemeColor.grey100,
                          child: Icon(
                            Icons.person,
                            color: ThemeColor.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    16.heightBox,
                    appointmentsAsync.when(
                      loading:
                          () => const SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ThemeColor.darkBlue,
                              ),
                            ),
                          ),
                      error:
                          (e, _) => SizedBox(
                            height: 180,
                            child: Center(
                              child: Text('Error loading appointment: $e'),
                            ),
                          ),
                      data: (appointments) {
                        final now = DateTime.now();

                        final upcomingApps =
                            appointments.where((app) {
                                return app.status ==
                                        AppointmentStatus.accepted &&
                                    app.dateTime.isAfter(now);
                              }).toList()
                              ..sort(
                                (a, b) => a.dateTime.compareTo(b.dateTime),
                              );

                        if (upcomingApps.isEmpty) {
                          return _buildEmptyUpcomingCard();
                        }

                        final nextApp = upcomingApps.first;
                        return _buildUpcomingCard(context, nextApp);
                      },
                    ),
                    16.heightBox,
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Training',
                            style: AppWidget.h3TextFieldStyle(),
                          ),
                          8.heightBox,
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Card(
                                    color: ThemeColor.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Training Resource',
                                        style: AppWidget.bodyMedium(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              shrinkWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.add, size: 18),
                                4.widthBox,
                                Text('Book New', style: AppWidget.bodyMedium()),
                              ],
                            ),
                          ),
                          8.widthBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.edit_note, size: 18),
                                4.widthBox,
                                GestureDetector(
                                  onTap:
                                      () => context.pushRoute(
                                        const ParentProgressRoute(),
                                      ),
                                  child: Text(
                                    'View Performance',
                                    style: AppWidget.bodyMedium(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          8.widthBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.how_to_reg, size: 18),
                                4.widthBox,
                                Text(
                                  'Sign Attendance',
                                  style: AppWidget.bodyMedium(),
                                ),
                              ],
                            ),
                          ),
                          8.widthBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.assignment_turned_in,
                                  size: 18,
                                ),
                                4.widthBox,
                                Text(
                                  'View Reports',
                                  style: AppWidget.bodyMedium(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, AppointmentModel app) {
    final now = DateTime.now();
    final aDate = DateTime(
      app.dateTime.year,
      app.dateTime.month,
      app.dateTime.day,
    );
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final timeStr = DateFormat('h:mm a').format(app.dateTime);
    String dateDisplay;

    if (aDate == DateTime(now.year, now.month, now.day)) {
      dateDisplay = 'Today, $timeStr';
    } else if (aDate == tomorrow) {
      dateDisplay = 'Tomorrow, $timeStr';
    } else {
      dateDisplay = DateFormat('d MMM, h:mm a').format(app.dateTime);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming Appointment', style: AppWidget.bodyLarge()),
          16.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: ThemeColor.grey100,
                    child: Icon(
                      Icons.person,
                      color: ThemeColor.white,
                      size: 30,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    app.trainerName,
                    style: AppWidget.bodySmall(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              16.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.aquaBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        app.sport,
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    8.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: ThemeColor.grey100,
                        ),
                        4.widthBox,
                        Text(dateDisplay, style: AppWidget.bodySmall()),
                      ],
                    ),
                    4.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: ThemeColor.grey100,
                        ),
                        4.widthBox,
                        Expanded(
                          child: Text(
                            app.location,
                            style: AppWidget.bodySmall(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  context.pushRoute(
                    ChatRoute(
                      trainerId: app.trainerId,
                      trainerName: app.trainerName,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColor.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Chat with Coach',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUpcomingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy, size: 48, color: ThemeColor.lightGrey),
          12.heightBox,
          Text(
            'No upcoming appointments',
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),
          8.heightBox,
          Text(
            'Book a new session to get started!',
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }
}
