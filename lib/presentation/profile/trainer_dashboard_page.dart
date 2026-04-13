import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';

@RoutePage()
class TrainerDashboardPage extends ConsumerWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authNotifierProvider).value;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
          tooltip: 'Go Back',
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Trainer Dashboard',
          style: AppWidget.h2TextFieldStyle().copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildPublicProfileCard(currentUser?.bio),
            _buildPublicProfileCard('testing'),

            32.heightBox,

            Text(
              'Training & Assessment Hub',
              style: AppWidget.h3TextFieldStyle(),
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

            Text('My Digital Certificate', style: AppWidget.h3TextFieldStyle()),
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
    );
  }

  Widget _buildPublicProfileCard(String? bio) {
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
            bio ??
                'Experienced in autism sports training.\nBased in Kuala Lumpur',
            style: AppWidget.bodySmall(),
          ),
          12.heightBox,
          const Row(
            children: [
              Icon(Icons.pool, size: 20, color: ThemeColor.darkBlue),
              SizedBox(width: 8),
              Icon(Icons.sports_soccer, size: 20, color: ThemeColor.black),
              SizedBox(width: 8),
              Icon(Icons.workspace_premium, size: 20, color: ThemeColor.orange),
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
