import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/appointment/appointment_notifier.dart';
import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/appointment_model.dart';
import '../../domain/models/transaction_model.dart';
import '../shared/curved_header_background.dart';
import '../shared/snack_bar.dart';
import '../shared/user_avatar.dart';
import 'shared/stat_item.dart';

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,\n${currentUser?.name ?? 'Trainer'}!',
                            style: AppWidget.h2TextFieldStyle(),
                          ),
                          UserAvatar(
                            radius: 24,
                            username:
                                currentUser?.name ?? currentUser?.nickname,
                            userAvatarUrl: currentUser?.userAvatarUrl,
                          ),
                        ],
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
                      height: 180,
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
                            return Center(
                              child: Text(
                                'No pending appointments',
                                style: AppWidget.bodyMedium().copyWith(
                                  color: ThemeColor.grey100,
                                ),
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
                            return Container(
                              padding: const EdgeInsets.all(24),
                              alignment: Alignment.center,
                              child: Text(
                                'No sessions today.',
                                style: AppWidget.bodyMedium().copyWith(
                                  color: ThemeColor.grey100,
                                ),
                              ),
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
                                session.parentName,
                                session.sport,
                                session.location,
                                !isLast,
                                session.parentId,
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
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: ThemeColor.grey100,
                    child: Icon(Icons.person, color: ThemeColor.white),
                  ),
                  4.heightBox,
                  Text(
                    'Parent',
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
                        Text(
                          appointment.parentName,
                          style: AppWidget.bodyLarge(),
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
                    4.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.pool,
                          size: 14,
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
    String name,
    String sport,
    String location,
    bool showLine,
    String parentId,
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
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: ThemeColor.grey100,
                    child: Icon(
                      Icons.person,
                      color: ThemeColor.white,
                      size: 24,
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: AppWidget.bodyLarge().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        4.heightBox,
                        Row(
                          children: [
                            const Icon(
                              Icons.pool,
                              size: 12,
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
                              ChatRoute(trainerId: parentId, trainerName: name),
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
}
