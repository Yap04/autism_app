import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning, \n${currentUser?.name ?? 'User'}!',
                          style: AppWidget.h2TextFieldStyle(),
                        ),
                        const Spacer(),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: ThemeColor.grey100,
                          child: Icon(
                            Icons.person,
                            color: ThemeColor.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    16.heightBox,
                    Container(
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
                          Text(
                            'Upcoming Appointment',
                            style: AppWidget.bodyLarge(),
                          ),
                          16.heightBox,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: ThemeColor.grey100,
                                    child: Icon(
                                      Icons.person,
                                      color: ThemeColor.white,
                                      size: 30,
                                    ),
                                  ),
                                  4.heightBox,
                                  Text(
                                    'Coach Dave',
                                    style: AppWidget.bodySmall(),
                                  ),
                                ],
                              ),
                              16.widthBox,
                              Column(
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
                                      'Swimming',
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
                                      Text(
                                        'Tomorrow, 10:00 AM',
                                        style: AppWidget.bodySmall(),
                                      ),
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
                                      Text(
                                        'Kuala Lumpur Sports Center',
                                        style: AppWidget.bodySmall(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          12.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ThemeColor.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Chat with Coach',
                                  style: AppWidget.bodySmall().copyWith(
                                    color: ThemeColor.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.heightBox,
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Training',
                            style: AppWidget.bodyLarge(),
                          ),
                          8.heightBox,
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Card(
                                    color: ThemeColor.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Training Resource',
                                        style: AppWidget.bodyMedium(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              shrinkWrap: true,
                            ),
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
                                Text(
                                  "Log Today's Performance",
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
                    8.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('Chatbot clicked!');
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColor.white,
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.black.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Image.asset(
                                  'asset/image/chatbot.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
