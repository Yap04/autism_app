import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/weekdays_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../shared/curved_header_background.dart';
import '../../shared/snack_bar.dart';
import '../../shared/user_avatar.dart';

class TrainerAppointmentsPage extends ConsumerStatefulWidget {
  const TrainerAppointmentsPage({super.key});

  @override
  ConsumerState<TrainerAppointmentsPage> createState() =>
      _TrainerAppointmentsPageState();
}

class _TrainerAppointmentsPageState
    extends ConsumerState<TrainerAppointmentsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _showPauseOptions(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: Text(context.l10n.pauseReceivingRequestsTitle),
            message: Text(context.l10n.pauseReceivingRequestsMessage),
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  context.l10n.pauseForOneHour,
                  style: AppWidget.bodyLarge(),
                ),
                onPressed: () {
                  ref
                      .read(authNotifierProvider.notifier)
                      .pauseAcceptingRequests(const Duration(hours: 1));
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  context.l10n.pauseForFourHours,
                  style: AppWidget.bodyLarge(),
                ),
                onPressed: () {
                  ref
                      .read(authNotifierProvider.notifier)
                      .pauseAcceptingRequests(const Duration(hours: 4));
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  context.l10n.pauseUntilTomorrow,
                  style: AppWidget.bodyLarge(),
                ),
                onPressed: () {
                  final now = DateTime.now();
                  final tomorrowEight = DateTime(
                    now.year,
                    now.month,
                    now.day + 1,
                    8,
                  );
                  ref
                      .read(authNotifierProvider.notifier)
                      .pauseAcceptingRequests(tomorrowEight.difference(now));
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                child: Text(
                  context.l10n.pauseUntilTurnedBackOn,
                  style: AppWidget.bodyLarge().copyWith(color: ThemeColor.red),
                ),
                onPressed: () {
                  ref
                      .read(authNotifierProvider.notifier)
                      .pauseAcceptingRequests(null);
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                context.l10n.cancelAction,
                style: AppWidget.bodyLarge(),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
    );
  }

  void _showOperatingHoursModal(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) {
      return;
    }

    final defaultSchedule = <Map<String, dynamic>>[
      {'day': 'Monday', 'isOpen': true, 'start': '08:00 AM', 'end': '10:00 PM'},
      {
        'day': 'Tuesday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {
        'day': 'Wednesday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {
        'day': 'Thursday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {'day': 'Friday', 'isOpen': true, 'start': '08:00 AM', 'end': '10:00 PM'},
      {
        'day': 'Saturday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {'day': 'Sunday', 'isOpen': true, 'start': '08:00 AM', 'end': '10:00 PM'},
    ];

    List<Map<String, dynamic>> weeklySchedule;

    if (currentUser.operatingHours != null &&
        currentUser.operatingHours!.isNotEmpty) {
      weeklySchedule =
          currentUser.operatingHours!
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
    } else {
      weeklySchedule = defaultSchedule.map(Map<String, dynamic>.from).toList();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: ThemeColor.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.only(
                top: 8,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ThemeColor.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  24.heightBox,

                  Text(
                    context.l10n.operatingHoursTitle,
                    style: AppWidget.h2TextFieldStyle(),
                  ),
                  8.heightBox,
                  Text(
                    context.l10n.operatingHoursDesc,
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                  24.heightBox,

                  Expanded(
                    child: ListView.separated(
                      itemCount: weeklySchedule.length,
                      separatorBuilder: (context, index) => 12.heightBox,
                      itemBuilder: (context, index) {
                        final schedule = weeklySchedule[index];
                        final isOpen = schedule['isOpen'] as bool;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ThemeColor.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isOpen
                                      ? ThemeColor.blue.withValues(alpha: 0.3)
                                      : ThemeColor.lightGrey,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 90,
                                child: Text(
                                  schedule['day'].toString().localized(context),
                                  style: AppWidget.bodyMedium().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isOpen
                                            ? ThemeColor.black
                                            : ThemeColor.grey100,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  isOpen
                                      ? '${schedule['start']} - ${schedule['end']}'
                                      : context.l10n.restDay,
                                  style: AppWidget.bodySmall().copyWith(
                                    color:
                                        isOpen
                                            ? ThemeColor.darkBlue
                                            : ThemeColor.grey100,
                                    fontWeight:
                                        isOpen
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              CupertinoSwitch(
                                value: isOpen,
                                activeTrackColor: ThemeColor.blue,
                                onChanged: (value) {
                                  setModalState(() {
                                    schedule['isOpen'] = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  16.heightBox,

                  GestureDetector(
                    onTap: () async {
                      try {
                        final updatedUser = currentUser.copyWith(
                          operatingHours: weeklySchedule,
                        );

                        await ref
                            .read(userRepositoryProvider)
                            .updateUser(updatedUser);

                        ref
                            .read(authNotifierProvider.notifier)
                            .updateLocalUser(updatedUser);

                        if (!context.mounted) {
                          return;
                        }

                        Navigator.pop(context);
                        AppSnackBar.success(
                          context,
                          context.l10n.operatingHoursUpdatedSuccess,
                        );
                      } catch (e) {
                        if (!context.mounted) {
                          return;
                        }
                        AppSnackBar.error(
                          context,
                          context.l10n.failedToUpdateOperatingHours(
                            e.toString(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ThemeColor.darkBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        context.l10n.saveChangesAction,
                        style: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser != null &&
        !currentUser.isAcceptingRequests &&
        currentUser.resumeAt != null &&
        DateTime.now().isAfter(currentUser.resumeAt!)) {
      Future.microtask(
        () => ref.read(authNotifierProvider.notifier).resumeAcceptingRequests(),
      );
    }

    final isAccepting = currentUser?.isAcceptingRequests ?? true;
    final resumeAt = currentUser?.resumeAt;
    final showResumeText =
        !isAccepting && resumeAt != null && DateTime.now().isBefore(resumeAt);

    var isSelectedDayOpen = true;
    final operatingHours = currentUser?.operatingHours ?? [];

    if (_selectedDay != null && operatingHours.isNotEmpty) {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      final dayString = weekdays[_selectedDay!.weekday - 1];

      final dayConfig = operatingHours.firstWhere(
        (e) => (e as Map)['day'] == dayString,
        orElse: () => null,
      );

      if (dayConfig != null) {
        isSelectedDayOpen = (dayConfig as Map)['isOpen'] == true;
      }
    }

    final isCurrentlyUnavailable = !isAccepting || !isSelectedDayOpen;

    final appointmentsAsync = ref.watch(appointmentNotifierProvider);
    final allAppointments = appointmentsAsync.value ?? [];

    final selectedDayAppointments =
        allAppointments.where((a) {
            if (_selectedDay == null) return false;
            return a.dateTime.year == _selectedDay!.year &&
                a.dateTime.month == _selectedDay!.month &&
                a.dateTime.day == _selectedDay!.day;
          }).toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      floatingActionButton: GestureDetector(
        onTap: () => _showOperatingHoursModal(context, ref),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColor.darkBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ThemeColor.darkBlue.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.access_time_rounded,
            color: ThemeColor.white,
            size: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 220,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.appointmentsTitle,
                      style: AppWidget.h2TextFieldStyle().copyWith(
                        color: ThemeColor.black,
                      ),
                    ),
                    24.heightBox,

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeColor.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.acceptingRequestsLabel,
                                style: AppWidget.bodyMedium().copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (showResumeText)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    context.l10n.autoResumesAtTime(
                                      DateFormat('hh:mm a').format(resumeAt),
                                    ),
                                    style: AppWidget.bodyExtraSmall().copyWith(
                                      color: ThemeColor.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          CupertinoSwitch(
                            value: isAccepting,
                            activeTrackColor: ThemeColor.blue,
                            onChanged: (value) async {
                              if (value) {
                                await ref
                                    .read(authNotifierProvider.notifier)
                                    .resumeAcceptingRequests();
                                AppSnackBar.success(
                                  context,
                                  context.l10n.youAreNowOnline,
                                );
                              } else {
                                _showPauseOptions(context, ref);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    24.heightBox,

                    TableCalendar(
                      firstDay: DateTime.utc(2023),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.week,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      headerVisible: false,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.black,
                          fontWeight: FontWeight.bold,
                        ),
                        weekendStyle: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                          color: ThemeColor.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                        todayDecoration: const BoxDecoration(
                          color: ThemeColor.aquaBlue,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        defaultTextStyle: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.black,
                        ),
                        weekendTextStyle: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.black,
                        ),
                      ),
                    ),
                    32.heightBox,

                    if (isCurrentlyUnavailable &&
                        selectedDayAppointments.isEmpty)
                      _buildUnavailableCard()
                    else if (selectedDayAppointments.isEmpty)
                      _buildEmptyState()
                    else
                      ...List.generate(selectedDayAppointments.length, (index) {
                        final appointment = selectedDayAppointments[index];
                        final isLast =
                            index == selectedDayAppointments.length - 1;

                        final hour = appointment.dateTime.hour;
                        final minute = appointment.dateTime.minute
                            .toString()
                            .padLeft(2, '0');
                        final period = hour >= 12 ? 'PM' : 'AM';
                        final displayHour =
                            hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
                        final timeString = '$displayHour:$minute\n$period';

                        Widget card;
                        if (appointment.status == AppointmentStatus.pending) {
                          card = _buildPendingCard(appointment);
                        } else if (appointment.status ==
                            AppointmentStatus.accepted) {
                          card = _buildBookedCard(appointment);
                        } else if (appointment.status ==
                            AppointmentStatus.completed) {
                          card = _buildCompletedCard(appointment);
                        } else {
                          return emptyBox;
                        }

                        return GestureDetector(
                          onTap:
                              () => context.pushRoute(
                                SessionDetailRoute(appointment: appointment),
                              ),
                          child: _buildTimelineItem(
                            time: timeString,
                            card: card,
                            showLine: !isLast,
                          ),
                        );
                      }),

                    80.heightBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required Widget card,
    required bool showLine,
  }) {
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
                    color: ThemeColor.black,
                  ),
                ),
                8.heightBox,
                if (showLine)
                  Expanded(
                    child: Container(width: 2, color: ThemeColor.lightGrey),
                  ),
              ],
            ),
          ),
          12.widthBox,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: card,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 48,
            color: ThemeColor.lightGrey,
          ),
          16.heightBox,
          Text(
            context.l10n.noAppointmentsYet,
            style: AppWidget.bodyMedium().copyWith(fontWeight: FontWeight.bold),
          ),
          4.heightBox,
          Text(
            context.l10n.parentsCanSendRequestsDesc,
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }

  Widget _buildBookedCard(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.aquaBlue, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(
            radius: 20,
            username: appointment.childName,
            userAvatarUrl: appointment.childAvatarUrl,
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
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                        color: ThemeColor.aquaBlue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.l10n.statusConfirmed,
                        style: AppWidget.bodyExtraSmall().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                4.heightBox,
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
                        color: ThemeColor.black,
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
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.grey100,
                        ),
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
    );
  }

  Widget _buildCompletedCard(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.lightGrey, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(
            radius: 20,
            username: appointment.childName,
            userAvatarUrl: appointment.childAvatarUrl,
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
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.grey100,
                        ),
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
                        color: ThemeColor.lightGrey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.l10n.statusCompleted,
                        style: AppWidget.bodyExtraSmall().copyWith(
                          color: ThemeColor.grey100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                4.heightBox,
                Row(
                  children: [
                    Icon(
                      getSportIcon(appointment.sport),
                      size: 16,
                      color: ThemeColor.grey100,
                    ),
                    4.widthBox,
                    Text(
                      appointment.sport,
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
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.grey100,
                        ),
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
    );
  }

  Widget _buildPendingCard(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColor.orange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: ThemeColor.orange,
            child: Icon(Icons.help_outline, color: ThemeColor.white, size: 24),
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
                      style: AppWidget.bodyMedium().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.actionRequiredShort,
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                4.heightBox,
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
                        color: ThemeColor.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ThemeColor.lightGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.block, size: 32, color: ThemeColor.grey100),
          8.heightBox,
          Text(
            context.l10n.notAcceptingRequestsTitle,
            style: AppWidget.bodyMedium().copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeColor.grey100,
            ),
          ),
        ],
      ),
    );
  }
}
