import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../application/appointment/appointment_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../shared/curved_header_background.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
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
                      'My Appointments',
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
                          _buildTabButton('Pending'),
                          _buildTabButton('Upcoming'),
                          _buildTabButton('Past'),
                        ],
                      ),
                    ),
                    24.heightBox,

                    Text(
                      _selectedDay != null
                          ? DateFormat(
                            'EEEE, d MMM',
                          ).format(_selectedDay!).toUpperCase()
                          : 'WEDNESDAY, 11 MAR',
                      style: AppWidget.bodyMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.grey100,
                        letterSpacing: 1.2,
                      ),
                    ),
                    12.heightBox,

                    ref
                        .watch(appointmentNotifierProvider)
                        .when(
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(
                                  color: ThemeColor.darkBlue,
                                ),
                              ),
                          error: (e, stack) => Center(child: Text('Error: $e')),
                          data: (appointments) {
                            final targetDate = _selectedDay ?? DateTime.now();
                            final filteredAppointments =
                                appointments.where((app) {
                                    final isSameDate =
                                        app.dateTime.year == targetDate.year &&
                                        app.dateTime.month ==
                                            targetDate.month &&
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
                                          app.status ==
                                              AppointmentStatus.cancelled;
                                    }
                                  }).toList()
                                  ..sort(
                                    (a, b) => a.dateTime.compareTo(b.dateTime),
                                  );

                            if (filteredAppointments.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: Text(
                                    'No ${_selectedTab.toLowerCase()} appointments for this date.',
                                    style: AppWidget.bodyMedium().copyWith(
                                      color: ThemeColor.grey100,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children:
                                  filteredAppointments.map((app) {
                                    final startStr = DateFormat(
                                      'hh:mm a',
                                    ).format(app.dateTime);
                                    final endStr = DateFormat('hh:mm a').format(
                                      app.dateTime.add(
                                        const Duration(hours: 1),
                                      ),
                                    );

                                    final statusStr =
                                        app.status.name[0].toUpperCase() +
                                        app.status.name.substring(1);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildAppointmentCard(
                                        time: '$startStr - $endStr',
                                        status: statusStr,
                                        coachName: app.trainerName,
                                        sport: app.sport,
                                        title: '${app.sport} Session',
                                        location: app.location,
                                        trainerId: app.trainerId,
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

  Widget _buildAppointmentCard({
    required String time,
    required String status,
    required String coachName,
    required String sport,
    required String title,
    required String location,
    required String trainerId,
  }) {
    return Container(
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
                  time,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: AppWidget.bodySmall().copyWith(
                    color:
                        status == 'Accepted'
                            ? ThemeColor.green
                            : status == 'Pending'
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
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: ThemeColor.grey100,
                    child: Icon(
                      Icons.person,
                      color: ThemeColor.white,
                      size: 30,
                    ),
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
                          const Icon(
                            Icons.pool,
                            size: 14,
                            color: ThemeColor.black,
                          ),
                          4.widthBox,
                          Text(
                            sport,
                            style: AppWidget.bodySmall().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.heightBox,
                    Text(
                      title,
                      style: AppWidget.bodyLarge().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: ThemeColor.grey100,
                        ),
                        4.widthBox,
                        Expanded(
                          child: Text(
                            location,
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
          20.heightBox,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap:
                      () => context.pushRoute(
                        ChatRoute(trainerId: trainerId, trainerName: coachName),
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ThemeColor.blue,
                      borderRadius: BorderRadius.circular(20),
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
              ),
              12.widthBox,
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeColor.lightGrey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Reschedule',
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

  Widget _buildTabButton(String title) {
    final isSelected = _selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? ThemeColor.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
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
