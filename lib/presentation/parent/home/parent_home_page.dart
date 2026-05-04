import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../application/content/content_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../../domain/models/feedback_model.dart';
import '../../shared/curved_header_background.dart';
import '../../shared/home_header_row.dart';
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
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ThemeColor.darkBlue,
                              ),
                            ),
                          ),
                      error:
                          (err, _) => SizedBox(
                            height: 300,
                            child: Center(
                              child: Text('Error loading data: $err'),
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

                        final completedApps =
                            appointments.where((app) {
                                return app.status ==
                                    AppointmentStatus.completed;
                              }).toList()
                              ..sort(
                                (a, b) => b.dateTime.compareTo(a.dateTime),
                              );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            upcomingApps.isEmpty
                                ? _buildEmptyUpcomingCard()
                                : _buildUpcomingCard(
                                  context,
                                  ref,
                                  upcomingApps.first,
                                ),

                            24.heightBox,

                            if (completedApps.isNotEmpty) ...[
                              Text(
                                "Child's Milestones",
                                style: AppWidget.h3TextFieldStyle(),
                              ),
                              12.heightBox,
                              _buildMilestonesBox(completedApps),
                              24.heightBox,
                            ],

                            if (completedApps.isNotEmpty) ...[
                              Text(
                                'Latest Session Insight',
                                style: AppWidget.h3TextFieldStyle(),
                              ),
                              12.heightBox,
                              _buildLatestInsightCard(
                                context,
                                ref,
                                completedApps.first,
                              ),
                              24.heightBox,
                            ],

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
                        );
                      },
                    ),
                    40.heightBox,
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

Widget _buildMilestonesBox(List<AppointmentModel> completedApps) {
  final totalSessions = completedApps.length;

  final totalMinutes = completedApps.fold<int>(
    0,
    (sum, app) => sum + app.duration,
  );
  final totalHours = (totalMinutes / 60).toStringAsFixed(1);

  var streak = 0;
  var checkDate = DateTime.now();
  for (final app in completedApps) {
    if (checkDate.difference(app.dateTime).inDays <= 14) {
      streak++;
      checkDate = app.dateTime;
    } else {
      break;
    }
  }

  return Row(
    children: [
      _buildMilestoneItem(
        'Total\nSessions',
        '$totalSessions',
        Icons.emoji_events,
        ThemeColor.orange,
      ),
      12.widthBox,
      _buildMilestoneItem(
        'Hours\nTrained',
        totalHours,
        Icons.timer,
        ThemeColor.blue,
      ),
      12.widthBox,
      _buildMilestoneItem(
        'Current\nStreak',
        '$streak',
        Icons.local_fire_department,
        ThemeColor.red,
      ),
    ],
  );
}

Widget _buildMilestoneItem(
  String label,
  String value,
  IconData icon,
  Color color,
) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          8.heightBox,
          Text(
            value,
            style: AppWidget.h2TextFieldStyle().copyWith(
              color: ThemeColor.black,
            ),
          ),
          4.heightBox,
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppWidget.bodyExtraSmall().copyWith(
              color: ThemeColor.grey100,
              height: 1.2,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLatestInsightCard(
  BuildContext context,
  WidgetRef ref,
  AppointmentModel latestAppt,
) {
  return FutureBuilder<FeedbackModel?>(
    future: ref
        .read(feedbackRepositoryProvider)
        .getFeedbackByAppointmentId(latestAppt.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(color: ThemeColor.darkBlue),
          ),
        );
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return emptyBox;
      }

      final feedback = snapshot.data!;
      final dateStr = DateFormat('dd MMM').format(latestAppt.dateTime);

      return GestureDetector(
        onTap:
            () =>
                context.pushRoute(SessionDetailRoute(appointment: latestAppt)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeColor.green.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeColor.green.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: ThemeColor.green,
                        size: 20,
                      ),
                      8.widthBox,
                      Text(
                        '${latestAppt.sport} • $dateStr',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Focus: ${feedback.focusLevel}/5',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              12.heightBox,
              Text(
                '"${feedback.remarks}"',
                style: AppWidget.bodyMedium().copyWith(
                  fontStyle: FontStyle.italic,
                  color: ThemeColor.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              12.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Full Report',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.widthBox,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: ThemeColor.darkBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
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
