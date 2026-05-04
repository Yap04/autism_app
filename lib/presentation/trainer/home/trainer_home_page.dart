import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../../domain/models/transaction_model.dart';
import '../../shared/curved_header_background.dart';
import '../../shared/home_header_row.dart';
import '../../shared/snack_bar.dart';
import '../../shared/user_avatar.dart';
import '../shared/stat_item.dart';

class TrainerHomePage extends ConsumerStatefulWidget {
  const TrainerHomePage({super.key});

  @override
  ConsumerState<TrainerHomePage> createState() => _TrainerHomePageState();
}

class _TrainerHomePageState extends ConsumerState<TrainerHomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final appointmentsAsync = ref.watch(appointmentNotifierProvider);

    final appointments = appointmentsAsync.value ?? [];

    final today = DateTime.now();
    final acceptedAppointments =
        appointments
            .where((a) => a.status == AppointmentStatus.accepted)
            .toList();

    final todaySessionsCount =
        acceptedAppointments
            .where(
              (a) =>
                  a.dateTime.year == today.year &&
                  a.dateTime.month == today.month &&
                  a.dateTime.day == today.day,
            )
            .length;

    // TODO: need the change the max slots
    const maxSlotsPerDay = 10;
    final availableSlots = (maxSlotsPerDay - todaySessionsCount).clamp(
      0,
      maxSlotsPerDay,
    );
    final slotProgress = availableSlots / maxSlotsPerDay;

    final uniqueParentsCount =
        acceptedAppointments.map((a) => a.parentId).toSet().length;

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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HomeHeaderRow(
                        userName: currentUser?.name,
                        fallbackName: 'trainer',
                      ),
                    ),
                    24.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ThemeColor.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeColor.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Summary Today',
                              style: AppWidget.bodyLarge().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            16.heightBox,
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatItem(
                                        label: 'Available\nSlots',
                                        valueWidget: SizedBox(
                                          height: 56,
                                          width: 56,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: slotProgress,
                                                strokeWidth: 6,
                                                backgroundColor: ThemeColor
                                                    .aquaBlue
                                                    .withValues(alpha: 0.4),
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                      Color
                                                    >(ThemeColor.darkBlue),
                                              ),
                                              Text(
                                                '$availableSlots',
                                                style:
                                                    AppWidget.h2TextFieldStyle(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: StatItem(
                                        label: 'Today\nSessions',
                                        value: '$todaySessionsCount',
                                      ),
                                    ),
                                    Expanded(
                                      child: StatItem(
                                        label: 'Total\nMembers',
                                        value: '$uniqueParentsCount',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    32.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'New Requests',
                        style: AppWidget.h3TextFieldStyle(),
                      ),
                    ),
                    12.heightBox,
                    SizedBox(
                      height: 210,
                      child: appointmentsAsync.when(
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(
                                color: ThemeColor.darkBlue,
                              ),
                            ),
                        error: (err, _) => Center(child: Text('Error: $err')),
                        data: (appointments) {
                          final pendingRequests =
                              appointments
                                  .where(
                                    (a) =>
                                        a.status == AppointmentStatus.pending,
                                  )
                                  .toList();

                          if (pendingRequests.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: _buildEmptyState(
                                'All Caught Up!',
                                'You have no pending requests at the moment.',
                                Icons.inbox_rounded,
                              ),
                            );
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: pendingRequests.length,
                            itemBuilder: (itemContext, index) {
                              final appointment = pendingRequests[index];
                              return _buildRequestCard(
                                context,
                                ref,
                                appointment,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    32.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Today Session Schedule',
                        style: AppWidget.h3TextFieldStyle(),
                      ),
                    ),
                    16.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: appointmentsAsync.when(
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error: (err, _) => Text('Error: $err'),
                        data: (appointments) {
                          final today = DateTime.now();
                          final todaySessions =
                              appointments.where((a) {
                                  return a.status ==
                                          AppointmentStatus.accepted &&
                                      a.dateTime.year == today.year &&
                                      a.dateTime.month == today.month &&
                                      a.dateTime.day == today.day;
                                }).toList()
                                ..sort(
                                  (a, b) => a.dateTime.compareTo(b.dateTime),
                                );

                          if (todaySessions.isEmpty) {
                            return _buildEmptyState(
                              'Free Schedule',
                              'You have no sessions scheduled for today. Enjoy your day!',
                              Icons.event_available_rounded,
                            );
                          }

                          return Column(
                            children: List.generate(todaySessions.length, (
                              index,
                            ) {
                              final session = todaySessions[index];

                              final hour = session.dateTime.hour;
                              final minute = session.dateTime.minute
                                  .toString()
                                  .padLeft(2, '0');
                              final period = hour >= 12 ? 'PM' : 'AM';
                              final displayHour =
                                  hour > 12
                                      ? hour - 12
                                      : (hour == 0 ? 12 : hour);
                              final timeString =
                                  '$displayHour:$minute\n$period';

                              // determine if the appointment is last, if yes then no connection line required
                              final isLast = index == todaySessions.length - 1;

                              return _buildTimelineItem(
                                timeString,
                                session.childName,
                                session.parentName,
                                session.childAvatarUrl,
                                session.sport,
                                session.location,
                                !isLast,
                                session.parentId,
                                session,
                              );
                            }),
                          );
                        },
                      ),
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

  Widget _buildRequestCard(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appointment,
  ) {
    final date = appointment.dateTime;
    final timeString =
        '${date.day}/${date.month}/${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  UserAvatar(
                    radius: 22,
                    username: appointment.childName,
                    userAvatarUrl: appointment.childAvatarUrl,
                  ),
                  4.heightBox,
                  Text(
                    'Student',
                    style: AppWidget.bodyExtraSmall().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                ],
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            appointment.childName,
                            style: AppWidget.bodyLarge(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColor.aquaBlue.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: ThemeColor.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              4.widthBox,
                              Text(
                                'New',
                                style: AppWidget.bodyExtraSmall().copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    2.heightBox,
                    Text(
                      'Parent: ${appointment.parentName}',
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    6.heightBox,
                    Row(
                      children: [
                        Icon(
                          getSportIcon(appointment.sport),
                          size: 16,
                          color: ThemeColor.darkBlue,
                        ),
                        4.widthBox,
                        Text(
                          appointment.sport,
                          style: AppWidget.bodySmall().copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    4.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: ThemeColor.grey100,
                        ),
                        4.widthBox,
                        Text(
                          timeString,
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                          ),
                        ),
                      ],
                    ),
                    2.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: ThemeColor.grey100,
                        ),
                        4.widthBox,
                        Expanded(
                          child: Text(
                            appointment.location,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppWidget.bodySmall().copyWith(
                              color: ThemeColor.grey100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap:
                      () => _handleStatusUpdate(
                        context,
                        ref,
                        appointment,
                        AppointmentStatus.accepted,
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeColor.darkBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Accept',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              12.widthBox,
              Expanded(
                child: GestureDetector(
                  onTap:
                      () => _handleStatusUpdate(
                        context,
                        ref,
                        appointment,
                        AppointmentStatus.rejected,
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ThemeColor.lightGrey),
                    ),
                    child: Text(
                      'Reject',
                      style: AppWidget.bodySmall().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildTimelineItem(
    String time,
    String childName,
    String parentName,
    String? childAvatarUrl,
    String sport,
    String location,
    bool showLine,
    String parentId,
    AppointmentModel appointment,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  time,
                  textAlign: TextAlign.center,
                  style: AppWidget.bodySmall().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.heightBox,
                if (showLine)
                  Expanded(
                    child: Container(width: 2, color: ThemeColor.aquaBlue),
                  ),
              ],
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap:
                  () => context.pushRoute(
                    SessionDetailRoute(appointment: appointment),
                  ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeColor.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColor.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    UserAvatar(
                      radius: 20,
                      username: childName,
                      userAvatarUrl: childAvatarUrl,
                    ),
                    12.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            childName,
                            style: AppWidget.bodyLarge().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          4.heightBox,
                          Row(
                            children: [
                              Icon(
                                getSportIcon(sport),
                                size: 16,
                                color: ThemeColor.darkBlue,
                              ),
                              4.widthBox,
                              Text(
                                sport,
                                style: AppWidget.bodySmall(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          4.heightBox,
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: ThemeColor.grey100,
                              ),
                              4.widthBox,
                              Expanded(
                                child: Text(
                                  location,
                                  style: AppWidget.bodySmall().copyWith(
                                    color: ThemeColor.grey100,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:
                              () => context.pushRoute(
                                ChatRoute(
                                  trainerId: parentId,
                                  trainerName: parentName,
                                ),
                              ),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: ThemeColor.darkBlue,
                            child: Icon(
                              Icons.chat_bubble,
                              color: ThemeColor.white,
                              size: 16,
                            ),
                          ),
                        ),
                        4.heightBox,
                        Text(
                          'Chat',
                          style: AppWidget.bodyExtraSmall().copyWith(
                            color: ThemeColor.darkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStatusUpdate(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appointment,
    AppointmentStatus status,
  ) async {
    try {
      final paymentChannel =
          appointment.paymentMethod == PaymentMethod.credit
              ? PaymentChannel.credit
              : PaymentChannel.stripe;

      await ref
          .read(appointmentNotifierProvider.notifier)
          .updateStatus(appointment.id, status, paymentChannel);
      if (context.mounted) {
        if (status == AppointmentStatus.accepted) {
          AppSnackBar.success(context, 'Appointment Accepted!');
        } else {
          AppSnackBar.info(context, 'Appointment Rejected!');
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, e.toString());
      }
    }
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: ThemeColor.grey100.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColor.aquaBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: ThemeColor.darkBlue),
          ),
          16.heightBox,
          Text(
            title,
            style: AppWidget.bodyLarge().copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeColor.darkBlue,
            ),
          ),
          8.heightBox,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }
}
