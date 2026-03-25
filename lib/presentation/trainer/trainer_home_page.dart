import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';

class TrainerHomePage extends StatelessWidget {
  const TrainerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                            'Good Morning,\nCoach Dave!',
                            style: AppWidget.h2TextFieldStyle(),
                          ),
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: ThemeColor.white,
                            child: Icon(
                              Icons.person,
                              color: ThemeColor.grey100,
                              size: 30,
                            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Baki Slots',
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.grey100,
                                      ),
                                    ),
                                    8.heightBox,
                                    SizedBox(
                                      height: 56,
                                      width: 56,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: 0.6,
                                            strokeWidth: 6,
                                            backgroundColor: ThemeColor.aquaBlue
                                                .withValues(alpha: 0.4),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(ThemeColor.darkBlue),
                                          ),
                                          Text(
                                            '8',
                                            style: AppWidget.h2TextFieldStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Sesi Hari Ini',
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.grey100,
                                      ),
                                    ),
                                    16.heightBox,
                                    Text(
                                      '4',
                                      style: AppWidget.h1TextFieldStyle(),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Jumlah Ahli',
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.grey100,
                                      ),
                                    ),
                                    16.heightBox,
                                    Text(
                                      '12',
                                      style: AppWidget.h1TextFieldStyle(),
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
                        'Permohonan Baru',
                        style: AppWidget.h3TextFieldStyle(),
                      ),
                    ),
                    12.heightBox,
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return _buildRequestCard(
                            ThemeColor.darkBlue,
                            ThemeColor.aquaBlue,
                          );
                        },
                      ),
                    ),
                    32.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Jadual Sesi',
                        style: AppWidget.h3TextFieldStyle(),
                      ),
                    ),
                    16.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildTimelineItem(
                            '10:00\nAM',
                            'Ahmad',
                            true,
                            ThemeColor.darkBlue,
                            ThemeColor.aquaBlue,
                          ),
                          _buildTimelineItem(
                            '11:00\nAM',
                            'Ahmad',
                            false,
                            ThemeColor.darkBlue,
                            ThemeColor.aquaBlue,
                          ),
                        ],
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

  Widget _buildRequestCard(Color darkBlue, Color aquaBlue) {
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
                  const Text(
                    'Parent',
                    style: TextStyle(fontSize: 10, color: ThemeColor.grey100),
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
                        Text('Ahmad', style: AppWidget.bodyLarge()),
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
                                  color: ThemeColor.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              4.widthBox,
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 10,
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
                          'Swimming',
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
                        const Text(
                          '14 Mac 2026, 10:00 AM',
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeColor.grey100,
                          ),
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
                        const Text(
                          'Pusat Sukan Kuala Lumpur',
                          style: TextStyle(
                            fontSize: 11,
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
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
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
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ThemeColor.lightGrey),
                    ),
                    child: Text(
                      'Tolak',
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
    bool showLine,
    Color darkBlue,
    Color aquaBlue,
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
                            Text('Berenang', style: AppWidget.bodySmall()),
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
                            Text(
                              'Kuala Lumpur',
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
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
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: ThemeColor.darkBlue,
                        child: Icon(
                          Icons.chat_bubble,
                          color: ThemeColor.white,
                          size: 16,
                        ),
                      ),
                      4.heightBox,
                      const Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 10,
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
}
