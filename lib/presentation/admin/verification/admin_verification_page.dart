import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/user/trainer_verification_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/snack_bar.dart';
import '../../shared/user_avatar.dart';

@RoutePage()
class AdminVerificationPage extends ConsumerWidget {
  const AdminVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(trainerApplicationsProvider);

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trainer Verification', style: AppWidget.h2TextFieldStyle()),
          8.heightBox,
          Text(
            'Manage all trainer registrations and history.',
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),
          24.heightBox,

          Container(
            decoration: BoxDecoration(
              color: ThemeColor.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              indicatorColor: ThemeColor.darkBlue,
              labelColor: ThemeColor.darkBlue,
              unselectedLabelColor: ThemeColor.grey100,
              labelStyle: AppWidget.bodyMedium().copyWith(
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected'),
              ],
            ),
          ),
          24.heightBox,

          Expanded(
            child: applicationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (allApps) {
                final pendingList =
                    allApps
                        .where(
                          (u) =>
                              u.verificationStatus ==
                              VerificationStatus.pending,
                        )
                        .toList();
                final approvedList =
                    allApps
                        .where(
                          (u) =>
                              u.verificationStatus ==
                              VerificationStatus.approved,
                        )
                        .toList();
                final rejectedList =
                    allApps
                        .where(
                          (u) =>
                              u.verificationStatus ==
                              VerificationStatus.rejected,
                        )
                        .toList();

                return TabBarView(
                  children: [
                    _buildList(
                      context,
                      ref,
                      pendingList,
                      'No pending applications.',
                    ),
                    _buildList(
                      context,
                      ref,
                      approvedList,
                      'No approved trainers yet.',
                    ),
                    _buildList(
                      context,
                      ref,
                      rejectedList,
                      'No rejected applications.',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> list,
    String emptyMessage,
  ) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: AppWidget.h3TextFieldStyle().copyWith(
            color: ThemeColor.grey100,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildApplicationCard(context, ref, list[index]);
      },
    );
  }

  Widget _buildApplicationCard(
    BuildContext context,
    WidgetRef ref,
    UserModel applicant,
  ) {
    final status = applicant.verificationStatus;
    final isPending = status == VerificationStatus.pending;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          UserAvatar(
            radius: 24,
            userAvatarUrl: applicant.userAvatarUrl,
            username: applicant.name,
          ),
          24.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant.name.toString(),
                  style: AppWidget.h3TextFieldStyle(),
                ),
                4.heightBox,
                Text(
                  applicant.email,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),

          if (!isPending)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    status == VerificationStatus.approved
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status.name.toUpperCase(),
                style: AppWidget.bodySmall().copyWith(
                  color:
                      status == VerificationStatus.approved
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          48.widthBox,

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap:
                  () => _showReviewDialog(
                    context,
                    ref,
                    applicant,
                    isPending: isPending,
                  ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      isPending
                          ? ThemeColor.darkBlue
                          : ThemeColor.lightGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPending ? 'Review Document' : 'View Details',
                  style: AppWidget.bodyMedium().copyWith(
                    color: isPending ? ThemeColor.white : ThemeColor.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
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
    UserModel applicant, {
    required bool isPending,
  }) {
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
              Text(
                isPending ? 'Review Application' : 'Application Details',
                style: AppWidget.h3TextFieldStyle(),
              ),
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
                  if (applicant.verificationStatus ==
                          VerificationStatus.rejected &&
                      applicant.rejectReason != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColor.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ThemeColor.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: ThemeColor.red,
                                size: 18,
                              ),
                              8.widthBox,
                              Text(
                                'Rejection Reason:',
                                style: AppWidget.bodySmall().copyWith(
                                  color: ThemeColor.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          4.heightBox,
                          Text(
                            applicant.rejectReason!,
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.heightBox,
                  ],

                  if (isPending) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColor.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ThemeColor.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.assignment_turned_in,
                            color: ThemeColor.orange,
                            size: 24,
                          ),
                          12.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Academy Assessment Check',
                                  style: AppWidget.bodyMedium().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColor.orange,
                                  ),
                                ),
                                4.heightBox,
                                Text(
                                  'Please verify that this applicant has passed the required Training Quiz in the Google Forms dashboard before approving.',
                                  style: AppWidget.bodySmall().copyWith(
                                    color: ThemeColor.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.heightBox,
                  ],

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
                    child: Text(
                      applicant.bio ?? 'No experience provided.',
                      style: AppWidget.bodyMedium(),
                    ),
                  ),

                  24.heightBox,
                  Text(
                    'Submitted Certificate(s):',
                    style: AppWidget.bodyMedium().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,

                  if (applicant.certificateUrls == null ||
                      applicant.certificateUrls!.isEmpty)
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeColor.cream,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('No certificates uploaded'),
                      ),
                    )
                  else
                    Column(
                      children:
                          applicant.certificateUrls!.map((url) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (_, _, _) => Container(
                                        height: 200,
                                        color: ThemeColor.lightGrey,
                                        child: const Center(
                                          child: Text('Image not found'),
                                        ),
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(24),
          actions:
              isPending
                  ? [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showRejectReasonDialog(context, ref, applicant.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: ThemeColor.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Reject',
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    16.widthBox,
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          _handleDecision(
                            context,
                            ref,
                            applicant.id,
                            isApproved: true,
                          );
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
                  ]
                  : [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
        );
      },
    );
  }

  void _showRejectReasonDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ThemeColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Reject Application',
            style: AppWidget.h3TextFieldStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide a reason for rejecting this application:',
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              16.heightBox,
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'e.g., Certificates are unclear, lack of experience...',
                  hintStyle: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                  filled: true,
                  fillColor: ThemeColor.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  AppSnackBar.error(
                    context,
                    'Please enter a rejection reason.',
                  );
                  return;
                }

                _handleDecision(
                  context,
                  ref,
                  userId,
                  isApproved: false,
                  reason: reason,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: ThemeColor.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Confirm Reject',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDecision(
    BuildContext context,
    WidgetRef ref,
    String userId, {
    required bool isApproved,
    String? reason,
  }) async {
    Navigator.pop(context);

    try {
      await ref
          .read(trainerVerificationNotifierProvider.notifier)
          .reviewApplication(
            userId: userId,
            isApproved: isApproved,
            reason: reason,
          );

      if (context.mounted) {
        if (isApproved) {
          AppSnackBar.success(context, 'Trainer approved successfully!');
        } else {
          AppSnackBar.success(
            context,
            'Application rejected and feedback sent.',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, 'Failed to update status: $e');
      }
    }
  }
}
