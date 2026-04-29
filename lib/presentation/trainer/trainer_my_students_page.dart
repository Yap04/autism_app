import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';
import 'shared/stat_item.dart';

class TrainerMyStudentsPage extends StatelessWidget {
  const TrainerMyStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 150,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Students', style: AppWidget.h1TextFieldStyle()),
                    24.heightBox,
                    Container(
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
                          Text('Summary', style: AppWidget.h3TextFieldStyle()),
                          16.heightBox,
                          const Row(
                            children: [
                              Expanded(
                                child: StatItem(
                                  label: 'Total\nStudents',
                                  value: '12',
                                ),
                              ),
                              Expanded(
                                child: StatItem(
                                  label: 'Active\nSessions',
                                  value: '8',
                                ),
                              ),
                              Expanded(
                                child: StatItem(
                                  label: 'Pending\nReports',
                                  value: '2',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    32.heightBox,

                    Text('Daftar Pelajar', style: AppWidget.h3TextFieldStyle()),
                    16.heightBox,

                    _buildStudentCard(
                      name: 'Ahmad',
                      sport: 'Berenang',
                      icon: Icons.pool,
                      lastSession: '11 Mac',
                      rating: '4.9',
                      progressPercent: 0.6,
                      hasNotification: true,
                    ),
                    16.heightBox,
                    _buildStudentCard(
                      name: 'Maya',
                      sport: 'Gymnastic',
                      icon: Icons.sports_gymnastics,
                      lastSession: '11 Mac',
                      rating: '4.9',
                      progressPercent: 0.4,
                      hasNotification: false,
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

  Widget _buildStudentCard({
    required String name,
    required String sport,
    required IconData icon,
    required String lastSession,
    required String rating,
    required double progressPercent,
    required bool hasNotification,
  }) {
    return Container(
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
              const CircleAvatar(
                radius: 24,
                backgroundColor: ThemeColor.grey100,
                child: Icon(Icons.person, color: ThemeColor.white, size: 30),
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
                          name,
                          style: AppWidget.bodyLarge().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: ThemeColor.lightOrange,
                              size: 16,
                            ),
                            4.widthBox,
                            Text(
                              rating,
                              style: AppWidget.bodyMedium().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    4.heightBox,
                    Row(
                      children: [
                        Icon(icon, size: 14, color: ThemeColor.darkBlue),
                        4.widthBox,
                        Text(
                          sport,
                          style: AppWidget.bodySmall().copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    4.heightBox,
                    Text(
                      'Last Session: $lastSession',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.heightBox,

          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeColor.lightGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressPercent,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: ThemeColor.darkBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          20.heightBox,

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ThemeColor.lightGrey,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'View Profile',
                      style: AppWidget.bodySmall().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              12.widthBox,

              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ThemeColor.darkBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Log Performance',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (hasNotification)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: ThemeColor.orange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ThemeColor.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
