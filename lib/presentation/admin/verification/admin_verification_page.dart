import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/snack_bar.dart';

class MockTrainerApp {
  MockTrainerApp({
    required this.id,
    required this.name,
    required this.email,
    required this.sport,
    required this.experience,
    required this.certificateUrl,
    required this.appliedAt,
  });
  final String id;
  final String name;
  final String email;
  final String sport;
  final String experience;
  final String certificateUrl;
  final DateTime appliedAt;
}

final pendingTrainersProvider = StateProvider<List<MockTrainerApp>>((ref) {
  return [
    MockTrainerApp(
      id: 't_001',
      name: 'John Doe',
      email: 'john.doe@email.com',
      sport: 'Basketball',
      experience: '3 years coaching special needs kids.',
      certificateUrl:
          'https://via.placeholder.com/600x400.png?text=Basketball+Coaching+Certificate',
      appliedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MockTrainerApp(
      id: 't_002',
      name: 'Sarah Lee',
      email: 'sarah.swim@email.com',
      sport: 'Swimming',
      experience: 'Certified aquatic therapist.',
      certificateUrl:
          'https://via.placeholder.com/600x400.png?text=Aquatic+Therapy+License',
      appliedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
});

@RoutePage()
class AdminVerificationPage extends ConsumerWidget {
  const AdminVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingList = ref.watch(pendingTrainersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trainer Verification',
                  style: AppWidget.h2TextFieldStyle(),
                ),
                8.heightBox,
                Text(
                  'Review and approve new trainer registrations.',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ThemeColor.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${pendingList.length} Pending',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        32.heightBox,
        Expanded(
          child:
              pendingList.isEmpty
                  ? Center(
                    child: Text(
                      'No pending applications! 🎉',
                      style: AppWidget.h3TextFieldStyle().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                  )
                  : ListView.separated(
                    itemCount: pendingList.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final app = pendingList[index];
                      return _buildApplicationCard(context, ref, app);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(
    BuildContext context,
    WidgetRef ref,
    MockTrainerApp app,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.lightGrey.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: ThemeColor.darkBlue.withValues(alpha: 0.1),
            child: Text(
              app.name.substring(0, 1),
              style: AppWidget.h3TextFieldStyle().copyWith(
                color: ThemeColor.darkBlue,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.name, style: AppWidget.h3TextFieldStyle()),
                const SizedBox(height: 4),
                Text(
                  app.email,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ThemeColor.darkBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              app.sport,
              style: AppWidget.bodySmall().copyWith(
                color: ThemeColor.darkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          48.widthBox,

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showReviewDialog(context, ref, app),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: ThemeColor.darkBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.fact_check_outlined,
                      color: ThemeColor.white,
                      size: 20,
                    ),
                    8.widthBox,
                    Text(
                      'Review Document',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(
    BuildContext context,
    WidgetRef ref,
    MockTrainerApp app,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Review Application', style: AppWidget.h3TextFieldStyle()),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Background & Experience:',
                    style: AppWidget.bodyMedium().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeColor.cream,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(app.experience, style: AppWidget.bodyMedium()),
                  ),

                  24.heightBox,
                  Text(
                    'Submitted Certificate:',
                    style: AppWidget.bodyMedium().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      app.certificateUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 300,
                            color: ThemeColor.lightGrey,
                            child: const Center(child: Text('Image not found')),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(24),
          actions: [
            // 🚀 替换 2：Reject 按钮 (空心边框效果)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _handleDecision(context, ref, app.id, isApproved: false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Reject',
                    style: AppWidget.bodyMedium().copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            16.widthBox,

            // 🚀 替换 3：Approve Trainer 按钮 (实心绿底效果)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _handleDecision(context, ref, app.id, isApproved: true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Approve Trainer',
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleDecision(
    BuildContext context,
    WidgetRef ref,
    String id, {
    required bool isApproved,
  }) {
    Navigator.pop(context);

    ref.read(pendingTrainersProvider.notifier).update((state) {
      return state.where((app) => app.id != id).toList();
    });

    // 3. 提示结果
    if (isApproved) {
      AppSnackBar.success(context, 'Trainer approved successfully!');
    } else {
      AppSnackBar.error(context, 'Application rejected.');
    }

    // TODO: 以后在这里加上 Firebase 的更新逻辑
    // await ref.read(userRepositoryProvider).updateUserStatus(id, UserStatus.active);
  }
}
