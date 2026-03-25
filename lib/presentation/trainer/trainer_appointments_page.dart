import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';

class TrainerAppointmentsPage extends StatefulWidget {
  const TrainerAppointmentsPage({super.key});

  @override
  State<TrainerAppointmentsPage> createState() =>
      _TrainerAppointmentsPageState();
}

class _TrainerAppointmentsPageState extends State<TrainerAppointmentsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isTodayAvailable = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ThemeColor.blue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: ThemeColor.white, size: 28),
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
                      'Appointments',
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
                          Text(
                            'Hari Ini Tersedia',
                            style: AppWidget.bodyMedium().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CupertinoSwitch(
                            value: _isTodayAvailable,
                            activeTrackColor: ThemeColor.blue,
                            onChanged: (value) {
                              setState(() {
                                _isTodayAvailable = value;
                              });
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

                    _buildTimelineItem(
                      time: '9:00\nAM',
                      card: _buildAvailableCard(),
                      showLine: true,
                    ),
                    _buildTimelineItem(
                      time: '10:00\nAM',
                      card: _buildBookedCard(),
                      showLine: true,
                    ),
                    _buildTimelineItem(
                      time: '11:00\nAM',
                      card: _buildUnavailableCard(),
                      showLine: true,
                    ),
                    _buildTimelineItem(
                      time: '12:00\nPM',
                      card: _buildAvailableCard(),
                      showLine: false,
                    ),

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

  Widget _buildAvailableCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: ThemeColor.aquaBlue.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available',
              style: AppWidget.bodyMedium().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.edit_calendar,
              size: 20,
              color: ThemeColor.darkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookedCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
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
            const CircleAvatar(
              radius: 20,
              backgroundColor: ThemeColor.grey100,
              child: Icon(Icons.person, color: ThemeColor.white, size: 24),
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
                        'Ahmad',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ThemeColor.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
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
                        'Berenang',
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
                        Icons.access_time,
                        size: 12,
                        color: ThemeColor.grey100,
                      ),
                      4.widthBox,
                      Text(
                        '10:00 AM',
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.grey100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ThemeColor.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Unavailable',
            style: AppWidget.bodyMedium().copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeColor.grey100,
            ),
          ),
          const Icon(Icons.block, size: 20, color: ThemeColor.grey100),
        ],
      ),
    );
  }
}
