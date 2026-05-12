import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/constant/weekdays_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/status_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../shared/curved_header_background.dart';
import '../../shared/snack_bar.dart';
import '../../shared/user_avatar.dart';

class ParentAppointmentsPage extends ConsumerStatefulWidget {
  const ParentAppointmentsPage({super.key});

  @override
  ConsumerState<ParentAppointmentsPage> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<ParentAppointmentsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedTab = 'Upcoming';

  bool _isDaySelectable(DateTime day, List<dynamic>? operatingHours) {
    if (operatingHours == null || operatingHours.isEmpty) {
      return true;
    }
    final dayString = Weekdays.all[day.weekday - 1];
    final dayConfig = operatingHours.firstWhere(
      (e) => (e as Map)['day'] == dayString,
      orElse: () => null,
    );
    return !(dayConfig != null) || (dayConfig as Map)['isOpen'] == true;
  }

  void _showRescheduleModal(
    BuildContext context,
    String appointmentId,
    String trainerId,
    DateTime currentDateTime,
  ) {
    var selectedDate = currentDateTime;
    TimeOfDay? selectedTime = TimeOfDay.fromDateTime(currentDateTime);
    var isLoading = false;

    final trainer = ref.read(fetchTrainerProvider(trainerId)).asData?.value;
    final operatingHours = trainer?.operatingHours;

    Map<String, dynamic>? getOperatingDay(DateTime date) {
      if (operatingHours == null || operatingHours.isEmpty) return null;
      final dayString = Weekdays.all[date.weekday - 1];
      final dayConfig = operatingHours.firstWhere(
        (e) => (e as Map)['day'] == dayString && e['isOpen'] == true,
        orElse: () => null,
      );
      return dayConfig != null
          ? Map<String, dynamic>.from(dayConfig as Map)
          : null;
    }

    TimeOfDay? parseTime(String? raw) {
      if (raw == null) {
        return null;
      }
      final parts = raw.split(':');
      if (parts.length < 2) {
        return null;
      }
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    String? validateTime(DateTime date, TimeOfDay time) {
      final now = DateTime.now();
      final proposed = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      if (proposed.isBefore(now)) {
        return context.l10n.cannotReschedulePast;
      }

      final dayConfig = getOperatingDay(date);
      if (dayConfig != null) {
        final open = parseTime(dayConfig['openTime'] as String?);
        final close = parseTime(dayConfig['closeTime'] as String?);

        if (open != null && close != null) {
          final openMinutes = open.hour * 60 + open.minute;
          final closeMinutes = close.hour * 60 + close.minute;
          final pickedMinutes = time.hour * 60 + time.minute;

          if (pickedMinutes < openMinutes || pickedMinutes >= closeMinutes) {
            String fmt(TimeOfDay t) =>
                '${t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
            return context.l10n.trainerAvailableTime(fmt(open), fmt(close));
          }
        }
      }
      return null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final validationError =
                selectedTime != null
                    ? validateTime(selectedDate, selectedTime!)
                    : null;
            final canConfirm =
                !isLoading && selectedTime != null && validationError == null;

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: ThemeColor.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      context.l10n.rescheduleSessionTitle,
                      style: AppWidget.h2TextFieldStyle(),
                    ),
                    16.heightBox,

                    Text(
                      context.l10n.selectNewDate,
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    8.heightBox,
                    GestureDetector(
                      onTap: () async {
                        var initialDate =
                            selectedDate.isBefore(DateTime.now())
                                ? DateTime.now().add(const Duration(days: 1))
                                : selectedDate;

                        while (!_isDaySelectable(initialDate, operatingHours)) {
                          initialDate = initialDate.add(
                            const Duration(days: 1),
                          );
                        }

                        final picked = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 90),
                          ),
                          selectableDayPredicate:
                              (day) => _isDaySelectable(day, operatingHours),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDate = picked;
                            selectedTime = null;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeColor.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ThemeColor.lightGrey),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: ThemeColor.darkBlue,
                              size: 20,
                            ),
                            12.widthBox,
                            Text(
                              DateFormat('dd MMM yyyy').format(selectedDate),
                              style: AppWidget.bodyLarge().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.heightBox,

                    Builder(
                      builder: (_) {
                        final dayConfig = getOperatingDay(selectedDate);
                        if (dayConfig == null) {
                          return emptyBox;
                        }
                        final open = parseTime(
                          dayConfig['openTime'] as String?,
                        );
                        final close = parseTime(
                          dayConfig['closeTime'] as String?,
                        );
                        if (open == null || close == null) {
                          return emptyBox;
                        }
                        String fmt(TimeOfDay t) =>
                            '${t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 14,
                                color: ThemeColor.grey100,
                              ),
                              4.widthBox,
                              Text(
                                context.l10n.availableTimeRange(
                                  fmt(open),
                                  fmt(close),
                                ),
                                style: AppWidget.bodySmall().copyWith(
                                  color: ThemeColor.grey100,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Text(
                      context.l10n.selectNewTime,
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    8.heightBox,
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setModalState(() => selectedTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              validationError != null
                                  ? ThemeColor.negative
                                  : ThemeColor.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ThemeColor.lightGrey),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: ThemeColor.darkBlue,
                              size: 20,
                            ),
                            12.widthBox,
                            Text(
                              selectedTime?.format(context) ??
                                  context.l10n.selectTimeHint,
                              style: AppWidget.bodyLarge().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (validationError != null) ...[
                      6.heightBox,
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 14,
                            color: ThemeColor.negative,
                          ),
                          4.widthBox,
                          Expanded(
                            child: Text(
                              validationError,
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.negative,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    32.heightBox,

                    GestureDetector(
                      onTap:
                          canConfirm
                              ? () async {
                                setModalState(() => isLoading = true);
                                try {
                                  final newDateTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime!.hour,
                                    selectedTime!.minute,
                                  );

                                  await ref
                                      .read(
                                        appointmentNotifierProvider.notifier,
                                      )
                                      .rescheduleAppointment(
                                        appointmentId: appointmentId,
                                        newDateTime: newDateTime,
                                      );

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    AppSnackBar.success(
                                      context,
                                      context.l10n.rescheduledSuccessfully,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    AppSnackBar.error(context, e.toString());
                                  }
                                  setModalState(() => isLoading = false);
                                }
                              }
                              : null,

                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isLoading || selectedTime == null
                                  ? ThemeColor.darkBlue.withValues(alpha: 0.5)
                                  : ThemeColor.darkBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: ThemeColor.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  context.l10n.confirmReschedule,
                                  style: AppWidget.bodyMedium().copyWith(
                                    color: ThemeColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsState = ref.watch(appointmentNotifierProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 120,
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.myAppointmentsTitle,
                      style: AppWidget.h2TextFieldStyle(),
                    ),
                    16.heightBox,
                    Container(
                      padding: const EdgeInsets.all(8),
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
                      child: TableCalendar(
                        firstDay: DateTime.utc(2023),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },

                        eventLoader: (day) {
                          return appointmentsState.maybeWhen(
                            data: (appointments) {
                              return appointments.where((app) {
                                return isSameDay(app.dateTime, day);
                              }).toList();
                            },
                            orElse: () => [],
                          );
                        },

                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },

                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: ThemeColor.black,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: ThemeColor.black,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                          ),
                          weekendStyle: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                          ),
                        ),
                        calendarStyle: const CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: ThemeColor.blue,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: ThemeColor.aquaBlue,
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: TextStyle(
                            color: ThemeColor.darkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          defaultTextStyle: TextStyle(color: ThemeColor.black),
                          weekendTextStyle: TextStyle(color: ThemeColor.black),
                          markersMaxCount: 1,
                          markerDecoration: BoxDecoration(
                            color: ThemeColor.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    24.heightBox,

                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: ThemeColor.lightGrey),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton('Pending', context.l10n.tabPending),
                          _buildTabButton('Upcoming', context.l10n.tabUpcoming),
                          _buildTabButton('Past', context.l10n.tabPast),
                        ],
                      ),
                    ),
                    24.heightBox,

                    Text(
                      _selectedDay != null
                          ? DateFormat(
                            'EEEE, d MMM',
                          ).format(_selectedDay!).toUpperCase()
                          : context.l10n.fallbackDatePlaceholder,
                      style: AppWidget.bodyMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.grey100,
                        letterSpacing: 1.2,
                      ),
                    ),
                    12.heightBox,

                    appointmentsState.when(
                      loading:
                          () => const Center(
                            child: CircularProgressIndicator(
                              color: ThemeColor.darkBlue,
                            ),
                          ),
                      error:
                          (err, _) => Center(
                            child: Text(
                              context.l10n.errorMessage(err.toString()),
                            ),
                          ),
                      data: (appointments) {
                        final targetDate = _selectedDay ?? DateTime.now();
                        final filteredAppointments =
                            appointments.where((app) {
                                final isSameDate =
                                    app.dateTime.year == targetDate.year &&
                                    app.dateTime.month == targetDate.month &&
                                    app.dateTime.day == targetDate.day;
                                if (!isSameDate) {
                                  return false;
                                }
                                if (_selectedTab == 'Pending') {
                                  return app.status ==
                                      AppointmentStatus.pending;
                                } else if (_selectedTab == 'Upcoming') {
                                  return app.status ==
                                      AppointmentStatus.accepted;
                                } else {
                                  return app.status ==
                                          AppointmentStatus.completed ||
                                      app.status ==
                                          AppointmentStatus.rejected ||
                                      app.status == AppointmentStatus.cancelled;
                                }
                              }).toList()
                              ..sort(
                                (a, b) => a.dateTime.compareTo(b.dateTime),
                              );

                        if (filteredAppointments.isEmpty) {
                          return _buildEmptyState();
                        }
                        return Column(
                          children:
                              filteredAppointments.map((app) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildAppointmentCard(
                                    context,
                                    appointment: app,
                                  ),
                                );
                              }).toList(),
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

  Widget _buildAppointmentCard(
    BuildContext context, {
    required AppointmentModel appointment,
  }) {
    final startTimeStr = DateFormat('hh:mm a').format(appointment.dateTime);
    final endTimeStr = DateFormat(
      'hh:mm a',
    ).format(appointment.dateTime.add(Duration(minutes: appointment.duration)));

    final timeRangeDisplay = '$startTimeStr - $endTimeStr';

    final status = appointment.status;
    final statusText = status.toLocalized(context);

    final now = DateTime.now();
    final hoursUntilSession = appointment.dateTime.difference(now).inHours;
    final isWithin24Hours =
        hoursUntilSession < 24 && appointment.dateTime.isAfter(now);

    final isRescheduleDisabled =
        status == AppointmentStatus.cancelled ||
        status == AppointmentStatus.rejected ||
        isWithin24Hours;

    final coachName = appointment.trainerName;
    final sport = appointment.sport;

    return GestureDetector(
      onTap:
          () => context.pushRoute(SessionDetailRoute(appointment: appointment)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(20),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: ThemeColor.aquaBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeRangeDisplay,
                    style: AppWidget.bodyMedium().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    statusText,
                    style: AppWidget.bodySmall().copyWith(
                      color:
                          status == AppointmentStatus.completed
                              ? ThemeColor.darkBlue
                              : status == AppointmentStatus.accepted
                              ? ThemeColor.green
                              : status == AppointmentStatus.pending
                              ? ThemeColor.orange
                              : ThemeColor.negative,
                    ),
                  ),
                ],
              ),
            ),
            16.heightBox,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final trainerAsync = ref.watch(
                          fetchTrainerProvider(appointment.trainerId),
                        );

                        return trainerAsync.when(
                          data:
                              (trainer) => UserAvatar(
                                radius: 28,
                                username: coachName,
                                userAvatarUrl: trainer?.userAvatarUrl,
                              ),
                          loading: () => const CircleAvatar(),
                          error:
                              (err, _) =>
                                  UserAvatar(radius: 28, username: coachName),
                        );
                      },
                    ),

                    6.heightBox,
                    Text(
                      coachName,
                      style: AppWidget.bodySmall().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColor.aquaBlue.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getSportIcon(sport),
                              size: 14,
                              color: ThemeColor.darkBlue,
                            ),
                            4.widthBox,
                            Text(
                              sport.toLocalizedSport(context),
                              style: AppWidget.bodySmall().copyWith(
                                fontWeight: FontWeight.w600,
                                color: ThemeColor.darkBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.heightBox,
                      Text(
                        context.l10n.sportSession(
                          sport.toLocalizedSport(context),
                        ),
                        style: AppWidget.bodyLarge().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.heightBox,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: ThemeColor.grey100,
                          ),
                          4.widthBox,
                          Expanded(
                            child: Text(
                              appointment.location,
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
                              ),
                              maxLines: 3,
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
            20.heightBox,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap:
                        () => context.pushRoute(
                          ChatRoute(
                            trainerId: appointment.trainerId,
                            trainerName: coachName,
                          ),
                        ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ThemeColor.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.l10n.chatWithCoach,
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
                  child:
                      status == AppointmentStatus.completed
                          ? GestureDetector(
                            onTap:
                                () => context.pushRoute(
                                  SessionDetailRoute(appointment: appointment),
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: ThemeColor.darkBlue),
                                borderRadius: BorderRadius.circular(20),
                                color: ThemeColor.aquaBlue.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              child: Text(
                                context.l10n.viewDetailsAction,
                                style: AppWidget.bodySmall().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColor.darkBlue,
                                ),
                              ),
                            ),
                          )
                          : GestureDetector(
                            onTap:
                                isRescheduleDisabled
                                    ? null
                                    : () {
                                      _showRescheduleModal(
                                        context,
                                        appointment.id,
                                        appointment.trainerId,
                                        appointment.dateTime,
                                      );
                                    },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: ThemeColor.lightGrey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                context.l10n.rescheduleAction,
                                style: AppWidget.bodySmall().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isRescheduleDisabled
                                          ? ThemeColor.grey100
                                          : ThemeColor.black,
                                ),
                              ),
                            ),
                          ),
                ),
              ],
            ),

            if (isWithin24Hours &&
                (status == AppointmentStatus.accepted ||
                    status == AppointmentStatus.pending)) ...[
              12.heightBox,
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: ThemeColor.orange,
                  ),
                  6.widthBox,
                  Expanded(
                    child: Text(
                      context.l10n.reschedulingDisabledWithin24h,
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.orange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    var localizedTab = '';
    if (_selectedTab == 'Pending') {
      localizedTab = context.l10n.tabPending.toLowerCase();
    } else if (_selectedTab == 'Upcoming') {
      localizedTab = context.l10n.tabUpcoming.toLowerCase();
    } else {
      localizedTab = context.l10n.tabPast.toLowerCase();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: ThemeColor.aquaBlue.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_note_rounded,
                    size: 44,
                    color: ThemeColor.darkBlue,
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: ThemeColor.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: ThemeColor.aquaBlue, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.question_mark_rounded,
                    size: 16,
                    color: ThemeColor.darkBlue,
                  ),
                ),
              ],
            ),
            20.heightBox,
            Text(
              context.l10n.noAppointmentsForTab(localizedTab),
              style: AppWidget.bodyLarge().copyWith(
                fontWeight: FontWeight.bold,
                color: ThemeColor.black,
              ),
            ),
            8.heightBox,
            Text(
              context.l10n.tapDateToViewOrBook,
              textAlign: TextAlign.center,
              style: AppWidget.bodySmall().copyWith(
                color: ThemeColor.grey100,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String id, String label) {
    final isSelected = _selectedTab == id;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = id;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? ThemeColor.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? ThemeColor.white : ThemeColor.grey100,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
