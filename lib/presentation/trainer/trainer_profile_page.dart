import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../shared/curved_header_background.dart';

class TrainerProfilePage extends ConsumerStatefulWidget {
  const TrainerProfilePage({super.key});

  @override
  ConsumerState<TrainerProfilePage> createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends ConsumerState<TrainerProfilePage> {
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Profile', style: AppWidget.h1TextFieldStyle()),
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signOut();
                            if (context.mounted) {
                              context.router.replaceAll([const LoginRoute()]);
                            }
                          },
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: ThemeColor.black,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    20.heightBox,

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ThemeColor.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ThemeColor.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: ThemeColor.grey100,
                            child: Icon(
                              Icons.person,
                              color: ThemeColor.white,
                              size: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5BA3A0),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ThemeColor.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.star,
                              color: ThemeColor.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.heightBox,

                    Text('Coach Dave', style: AppWidget.h2TextFieldStyle()),
                    24.heightBox,

                    _buildPublicProfileCard(),
                    32.heightBox,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Training & Assessment Hub',
                        style: AppWidget.h3TextFieldStyle(),
                      ),
                    ),
                    16.heightBox,
                    SizedBox(
                      height: 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTrainingCard(
                              title: 'Basic Practice Module',
                              statusText: '100% Completed',
                              showProgressBar: true,
                              buttonText: '',
                            ),
                            16.widthBox,
                            _buildTrainingCard(
                              title: 'Sports Training Autism (Level 1)',
                              statusText: 'On Going',
                              showProgressBar: false,
                              buttonText: 'Start Assessment',
                            ),
                          ],
                        ),
                      ),
                    ),
                    32.heightBox,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Digital Certificate',
                        style: AppWidget.h3TextFieldStyle(),
                      ),
                    ),
                    16.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCertificateCard(
                            title: 'Autism Training\nCertified',
                            date: '23 Mac 2026, Kuala Lumpur',
                            iconColor: ThemeColor.blue,
                          ),
                          16.widthBox,
                          _buildCertificateCard(
                            title: 'First Aid Emergency Course',
                            date: '23 Mac 2026, Kuala Lumpur',
                            iconColor: ThemeColor.green,
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

  Widget _buildPublicProfileCard() {
    return Container(
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
            'Your Public Profile',
            style: AppWidget.bodyMedium().copyWith(fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          Text(
            'Bio is surname sports in and traineor.\nSporteet mis Kuala Lumpur',
            style: AppWidget.bodySmall(),
          ),
          12.heightBox,
          Row(
            children: [
              const Icon(Icons.pool, size: 20, color: ThemeColor.darkBlue),
              8.widthBox,
              const Icon(
                Icons.sports_soccer,
                size: 20,
                color: ThemeColor.black,
              ),
              8.widthBox,
              const Icon(
                Icons.workspace_premium,
                size: 20,
                color: ThemeColor.orange,
              ),
            ],
          ),
          20.heightBox,
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ThemeColor.lightGrey, width: 1.5),
              ),
              child: Text(
                'Public Profile Update',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard({
    required String title,
    required String statusText,
    required bool showProgressBar,
    required String buttonText,
  }) {
    return Container(
      width: 160,
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
          Text(
            title,
            style: AppWidget.bodyMedium().copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          16.heightBox,
          Text(
            statusText,
            style: AppWidget.bodySmall().copyWith(fontWeight: FontWeight.w600),
          ),
          12.heightBox,
          if (showProgressBar)
            Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeColor.lightGrey,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  height: 6,
                  width: 100,
                  decoration: BoxDecoration(
                    color: ThemeColor.darkBlue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            )
          else if (buttonText.isNotEmpty)
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ThemeColor.darkBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  buttonText,
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard({
    required String title,
    required String date,
    required Color iconColor,
  }) {
    return Container(
      width: 260,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.workspace_premium, color: iconColor, size: 28),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                6.heightBox,
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: ThemeColor.green,
                    ),
                    4.widthBox,
                    Text(
                      'Confirmed',
                      style: AppWidget.bodySmall().copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.green,
                      ),
                    ),
                  ],
                ),
                4.heightBox,
                Text(
                  date,
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
