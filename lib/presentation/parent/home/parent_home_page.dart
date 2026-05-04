import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../application/content/parent_content_provider.dart';
import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../shared/curved_header_background.dart';
import '../../shared/user_avatar.dart';
import 'content/shared/content_card.dart';

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
    final contentAsync = ref.watch(parentPublishedContentProvider);

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
                    HomeHeaderRow(
                      userName: currentUser?.name,
                      fallbackName: 'parent',
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
                        return _buildUpcomingCard(context, ref, nextApp);
                      },
                    ),
                    16.heightBox,
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Resources for You',
                                style: AppWidget.h3TextFieldStyle(),
                              ),
                              GestureDetector(
                                onTap:
                                    () => context.pushRoute(
                                      const ContentListRoute(),
                                    ),
                                child: Row(
                                  children: [
                                    Text(
                                      'View More',
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: ThemeColor.darkBlue,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          8.heightBox,
                          contentAsync.when(
                            loading:
                                () => const SizedBox(
                                  height: 160,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ThemeColor.darkBlue,
                                    ),
                                  ),
                                ),
                            error:
                                (e, _) => SizedBox(
                                  height: 160,
                                  child: Center(
                                    child: Text(
                                      'Failed to load content.',
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.red,
                                      ),
                                    ),
                                  ),
                                ),
                            data: (contents) {
                              if (contents.isEmpty) {
                                return Container(
                                  height: 120,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ThemeColor.white.withValues(
                                      alpha: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'More resources coming soon!',
                                    style: AppWidget.bodyMedium().copyWith(
                                      color: ThemeColor.grey100,
                                    ),
                                  ),
                                );
                              }

                              return SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: contents.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: 240,
                                      child: buildContentCard(
                                        context,
                                        ref,
                                        contents[index],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
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
}

Widget _buildUpcomingCard(
  BuildContext context,
  WidgetRef ref,
  AppointmentModel app,
) {
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

  final trainerAsync = ref.watch(fetchTrainerProvider(app.trainerId));

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
                trainerAsync.when(
                  data: (trainer) {
                    return UserAvatar(
                      radius: 30,
                      username:
                          trainer?.name ?? trainer?.nickname ?? app.trainerName,
                      userAvatarUrl: trainer?.userAvatarUrl,
                    );
                  },
                  loading:
                      () => const CircleAvatar(
                        radius: 30,
                        backgroundColor: ThemeColor.grey100,
                        child: CircularProgressIndicator(
                          color: ThemeColor.white,
                          strokeWidth: 2,
                        ),
                      ),
                  error:
                      (_, _) => const CircleAvatar(
                        radius: 30,
                        backgroundColor: ThemeColor.grey100,
                        child: Icon(
                          Icons.error_outline,
                          color: ThemeColor.white,
                          size: 30,
                        ),
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
