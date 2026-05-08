import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/appointment/appointment_notifier.dart';
import '../../application/auth/auth_notifier.dart';
import '../../application/child/child_provider.dart';
import '../../application/providers/repository_providers.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/sport_ext.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/appointment_model.dart';
import '../../domain/models/child_model.dart';
import '../../domain/models/feedback_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../infrastructure/services/commision_service.dart';
import '../../infrastructure/services/sla_service.dart';
import '../parent/feedback/rate_review_bottom_sheet.dart';
import '../shared/bottom_action_button.dart';
import '../shared/snack_bar.dart';
import '../shared/user_avatar.dart';
import '../trainer/feedback/feedback_bottom_sheet.dart';

@RoutePage()
class SessionDetailPage extends ConsumerStatefulWidget {
  const SessionDetailPage({required this.appointment, super.key});
  final AppointmentModel appointment;

  @override
  ConsumerState<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends ConsumerState<SessionDetailPage> {
  bool _isLoading = false;
  FeedbackModel? _cachedFeedback;
  bool _feedbackLoaded = false;

  Future<void> _loadFeedback() async {
    if (_feedbackLoaded) {
      return;
    }
    final feedback = await ref
        .read(feedbackRepositoryProvider)
        .getFeedbackByAppointmentId(widget.appointment.id);
    if (mounted) {
      setState(() {
        _cachedFeedback = feedback;
        _feedbackLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.appointment.status == AppointmentStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFeedback());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment;
    final dateStr = DateFormat('EEEE, dd MMM yyyy').format(appt.dateTime);
    final timeStr = DateFormat('hh:mm a').format(appt.dateTime);
    final endTimeStr = DateFormat(
      'hh:mm a',
    ).format(appt.dateTime.add(Duration(minutes: appt.duration)));

    final childAsync = ref.watch(childDetailsProvider(appt.childId));

    final currentUser = ref.watch(authNotifierProvider).value;
    final isParent = currentUser?.id == appt.parentId;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 0,
        centerTitle: true,
        title: Text('Session Details', style: AppWidget.h3TextFieldStyle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentCard(appt, childAsync, isParent: isParent),
            24.heightBox,

            Row(
              children: [
                Expanded(
                  child: _buildInfoBox(
                    title: 'Status',
                    value: appt.status.name.toUpperCase(),
                    valueColor: _getStatusColor(appt.status),
                    icon: Icons.info_outline,
                  ),
                ),
                16.widthBox,
                Expanded(
                  child: _buildInfoBox(
                    title: 'Payment',
                    value: appt.paymentStatus.name.toUpperCase(),
                    valueColor: ThemeColor.green,
                    icon: Icons.payment,
                  ),
                ),
              ],
            ),
            24.heightBox,

            Text('Schedule & Location', style: AppWidget.h3TextFieldStyle()),
            12.heightBox,
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeColor.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.calendar_today, 'Date', dateStr),
                  const Divider(height: 24, color: ThemeColor.lightGrey),
                  _buildDetailRow(
                    Icons.access_time,
                    'Time',
                    '$timeStr - $endTimeStr (${appt.duration} mins)',
                  ),
                  const Divider(height: 24, color: ThemeColor.lightGrey),
                  _buildDetailRow(
                    getSportIcon(appt.sport),
                    'Sport',
                    appt.sport,
                  ),
                  const Divider(height: 24, color: ThemeColor.lightGrey),
                  _buildDetailRow(Icons.location_on, 'Location', appt.location),
                ],
              ),
            ),
            24.heightBox,

            if (appt.sessionType == SessionType.remote) ...[
              Text('Remote Consultation', style: AppWidget.h3TextFieldStyle()),
              12.heightBox,
              _buildRemoteConsultationBox(context, appt, isParent: isParent),
              24.heightBox,
            ],

            Text('Special Needs & Notes', style: AppWidget.h3TextFieldStyle()),
            12.heightBox,
            _buildSpecialNeedsBox(childAsync),
            24.heightBox,

            if (appt.status == AppointmentStatus.completed) ...[
              Text('Session Feedback', style: AppWidget.h3TextFieldStyle()),
              12.heightBox,
              _buildFeedbackBox(context, ref, appt.id),
            ],

            40.heightBox,
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomActionBar(
        context,
        ref,
        appt,
        isParent: isParent,
      ),
    );
  }

  Widget _buildStudentCard(
    AppointmentModel appt,
    AsyncValue<ChildModel?> childAsync, {
    required bool isParent,
  }) {
    final childData = childAsync.valueOrNull;
    var subtitle = appt.childName;

    if (childData != null) {
      final genderText =
          (childData.gender != null && childData.gender!.isNotEmpty)
              ? ', ${childData.gender}'
              : '';
      subtitle = '(${childData.age}y$genderText)';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.darkBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.darkBlue.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(
            radius: 32,
            username: appt.childName,
            userAvatarUrl: appt.childAvatarUrl,
          ),
          16.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt.childName,
                  style: AppWidget.h3TextFieldStyle().copyWith(
                    color: ThemeColor.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                4.heightBox,
                Text(
                  subtitle,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                4.heightBox,

                Text(
                  'Parent: ${appt.parentName}',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isParent)
            GestureDetector(
              onTap:
                  () => context.pushRoute(
                    ChatRoute(
                      trainerId: appt.parentId,
                      trainerName: appt.parentName,
                    ),
                  ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeColor.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: ThemeColor.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRemoteConsultationBox(
    BuildContext context,
    AppointmentModel appt, {
    required bool isParent,
  }) {
    final canJoinCall = appt.status == AppointmentStatus.accepted;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.aquaBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam_rounded, color: ThemeColor.darkBlue),
              8.widthBox,
              Text(
                'In-App Video Session',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.darkBlue,
                ),
              ),
            ],
          ),
          8.heightBox,
          Text(
            'This session will be conducted remotely. Please ensure you have a stable internet connection before joining.',
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
          ),

          if (canJoinCall) ...[
            16.heightBox,
            GestureDetector(
              onTap: () {
                context.pushRoute(
                  VideoCallRoute(
                    channelName: appt.id,
                    role: isParent ? 'subscriber' : 'publisher',
                  ),
                );

                AppSnackBar.success(
                  context,
                  'Navigating to Video Call Room...',
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ThemeColor.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColor.darkBlue.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.video_call_rounded,
                      color: ThemeColor.white,
                      size: 20,
                    ),
                    8.widthBox,
                    Text(
                      'Join Video Call',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (appt.status == AppointmentStatus.completed) ...[
            16.heightBox,
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: ThemeColor.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Video session ended',
                style: AppWidget.bodyExtraSmall().copyWith(
                  color: ThemeColor.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeedbackBox(
    BuildContext context,
    WidgetRef ref,
    String appointmentId,
  ) {
    if (!_feedbackLoaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: ThemeColor.darkBlue),
        ),
      );
    }

    if (_cachedFeedback == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ThemeColor.lightGrey.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          'No feedback provided yet.',
          style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
        ),
      );
    }

    final feedback = _cachedFeedback!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Focus & Attention',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${feedback.focusLevel}/5',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          8.heightBox,
          LinearProgressIndicator(
            value: feedback.focusLevel / 5,
            backgroundColor: ThemeColor.lightGrey.withValues(alpha: 0.3),
            color: ThemeColor.darkBlue,
            borderRadius: BorderRadius.circular(4),
          ),

          24.heightBox,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Energy Level',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${feedback.energyLevel}/5',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          8.heightBox,
          LinearProgressIndicator(
            value: feedback.energyLevel / 5,
            backgroundColor: ThemeColor.lightGrey.withValues(alpha: 0.3),
            color: ThemeColor.darkBlue,
            borderRadius: BorderRadius.circular(4),
          ),

          24.heightBox,

          // Trainer Remarks
          Text(
            'Trainer Remarks',
            style: AppWidget.bodyMedium().copyWith(fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColor.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              feedback.remarks,
              style: AppWidget.bodyMedium().copyWith(color: ThemeColor.black),
            ),
          ),

          // Parent Review
          if (feedback.rating != null) ...[
            24.heightBox,
            const Divider(color: ThemeColor.lightGrey),
            24.heightBox,
            Text(
              'Parent Review',
              style: AppWidget.bodyMedium().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.heightBox,
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  (feedback.rating ?? 0) > index
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 24,
                  color: ThemeColor.orange,
                );
              }),
            ),
            if (feedback.review != null && feedback.review!.isNotEmpty) ...[
              8.heightBox,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeColor.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  feedback.review!,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.black,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSpecialNeedsBox(AsyncValue<ChildModel?> childAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.orange.withValues(alpha: 0.3)),
      ),
      child: childAsync.when(
        loading:
            () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: ThemeColor.orange),
              ),
            ),
        error:
            (err, _) => Text(
              'Error loading details.',
              style: AppWidget.bodySmall().copyWith(color: ThemeColor.orange),
            ),
        data: (child) {
          if (child == null) {
            return Text(
              'Child data not found.',
              style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
            );
          }

          final hasSpecialNeeds = child.specialNeeds.isNotEmpty;
          final hasRemarks =
              child.remarks != null && child.remarks!.trim().isNotEmpty;

          if (!hasSpecialNeeds && !hasRemarks) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: ThemeColor.orange,
                      size: 20,
                    ),
                    8.widthBox,
                    Text(
                      'Notes',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                8.heightBox,
                Text(
                  'No specific special needs or remarks provided by the parent.',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSpecialNeeds) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: ThemeColor.orange,
                      size: 20,
                    ),
                    8.widthBox,
                    Text(
                      'Special Needs',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                12.heightBox,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      child.specialNeeds
                          .map(
                            (need) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeColor.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ThemeColor.orange.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                need,
                                style: AppWidget.bodySmall().copyWith(
                                  color: ThemeColor.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                if (hasRemarks) 20.heightBox,
              ],

              if (hasRemarks) ...[
                Row(
                  children: [
                    const Icon(Icons.notes, color: ThemeColor.orange, size: 20),
                    8.widthBox,
                    Text(
                      'Parent Remarks',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                8.heightBox,
                Text(
                  child.remarks!,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.black,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: ThemeColor.grey100),
              6.widthBox,
              Text(
                title,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
            ],
          ),
          8.heightBox,
          Text(
            value,
            style: AppWidget.bodyMedium().copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: ThemeColor.darkBlue),
        16.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              4.heightBox,
              Text(
                value,
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return ThemeColor.orange;
      case AppointmentStatus.accepted:
        return ThemeColor.darkBlue;
      case AppointmentStatus.completed:
        return ThemeColor.green;
      case AppointmentStatus.rejected:
      case AppointmentStatus.cancelled:
        return ThemeColor.red;
    }
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appt, {
    required bool isParent,
  }) {
    final endTime = appt.dateTime.add(Duration(minutes: appt.duration));
    final isPast = DateTime.now().isAfter(endTime);
    final canComplete = appt.status == AppointmentStatus.accepted && isPast;

    if (appt.status == AppointmentStatus.completed) {
      final hasReview = _cachedFeedback?.rating != null;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child:
              isParent
                  ? (hasReview
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: ThemeColor.green,
                          ),
                          8.widthBox,
                          Text(
                            'Review Submitted',
                            style: AppWidget.h3TextFieldStyle().copyWith(
                              color: ThemeColor.green,
                            ),
                          ),
                        ],
                      )
                      : BottomActionButton(
                        label: 'Rate & Review Trainer',
                        isLoading: _isLoading,
                        backgroundColor: ThemeColor.orange,
                        onPressed: () => _handleRateReview(context, ref, appt),
                      ))
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: ThemeColor.green),
                      8.widthBox,
                      Text(
                        'Session Completed',
                        style: AppWidget.h3TextFieldStyle().copyWith(
                          color: ThemeColor.green,
                        ),
                      ),
                    ],
                  ),
        ),
      );
    }

    if (appt.status == AppointmentStatus.accepted && isParent) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomActionButton(
            label: 'Cancel Session',
            isLoading: _isLoading,
            backgroundColor: ThemeColor.red,
            onPressed: () => _showCancellationPolicyDialog(context, ref, appt),
          ),
        ),
      );
    }

    if (appt.status == AppointmentStatus.accepted && !isParent) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomActionButton(
            label:
                canComplete ? 'Mark as Completed' : 'Waiting for Session Time',
            isLoading: _isLoading,
            backgroundColor: ThemeColor.green,
            onPressed:
                canComplete
                    ? () => _handleMarkAsCompleted(context, ref, appt)
                    : null,
          ),
        ),
      );
    }

    return emptyBox;
  }

  Future<void> _showCancellationPolicyDialog(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appt,
  ) async {
    final sla = SlaService.calculateCancellation(appt);
    final currentUser = ref.read(authNotifierProvider).value;

    final isFree = sla['isFree'] as bool;
    final slaMessage = sla['message'] as String;
    final refundAmount = sla['refundAmount'] as double;

    final hasGrace = (currentUser?.meltdownGraceUsedThisMonth ?? 0) < 1;
    var useGrace = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: ThemeColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cancel Session', style: AppWidget.h2TextFieldStyle()),
                    16.heightBox,

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColor.cream,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        useGrace
                            ? 'Meltdown Grace applied: You will receive a full refund.'
                            : slaMessage,
                        style: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.darkBlue,
                        ),
                      ),
                    ),
                    24.heightBox,

                    if (!isFree && hasGrace) ...[
                      CheckboxListTile(
                        value: useGrace,
                        activeColor: ThemeColor.darkBlue,
                        title: Text(
                          'Sudden Meltdown? (Grace Period)',
                          style: AppWidget.bodyMedium().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          "Use your monthly 1-time grace for a full refund due to child's condition.",
                        ),
                        onChanged: (val) {
                          setModalState(() => useGrace = val ?? false);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      12.heightBox,
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Refund:', style: AppWidget.bodyMedium()),
                        Text(
                          'RM ${useGrace ? appt.amount.toStringAsFixed(2) : refundAmount.toStringAsFixed(2)}',
                          style: AppWidget.h3TextFieldStyle().copyWith(
                            color: ThemeColor.green,
                          ),
                        ),
                      ],
                    ),
                    32.heightBox,

                    BottomActionButton(
                      label: 'Confirm Cancellation',
                      backgroundColor: ThemeColor.red,
                      isLoading: _isLoading,
                      onPressed: () async {
                        Navigator.pop(context);
                        await _handleCancelAppointment(appt, useGrace, sla);
                      },
                    ),
                    12.heightBox,
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Keep Session',
                          style: AppWidget.bodyMedium().copyWith(
                            color: ThemeColor.grey100,
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

  Future<void> _handleCancelAppointment(
    AppointmentModel appt,
    bool useGrace,
    Map<String, dynamic> sla,
  ) async {
    setState(() => _isLoading = true);

    try {
      final refund = useGrace ? appt.amount : (sla['refundAmount'] as double);
      final compensation =
          useGrace ? 0.0 : (sla['trainerCompensation'] as double);

      await ref
          .read(appointmentNotifierProvider.notifier)
          .cancelAppointment(
            appointment: appt,
            refundToParent: refund,
            compensationToTrainer: compensation,
            isMeltdownGrace: useGrace,
          );

      AppSnackBar.success(context, 'Appointment cancelled successfully.');
      context.router.maybePop();
    } catch (e) {
      AppSnackBar.error(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleMarkAsCompleted(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appt,
  ) async {
    final feedbackData = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FeedbackBottomSheet(),
    );

    if (feedbackData == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser == null) {
        throw Exception('Please login first');
      }

      final feedbackId = 'fb_${DateTime.now().millisecondsSinceEpoch}';
      final newFeedback = FeedbackModel(
        id: feedbackId,
        appointmentId: appt.id,
        childId: appt.childId,
        trainerId: currentUser.id,
        focusLevel: feedbackData['focus'] as int,
        energyLevel: feedbackData['energy'] as int,
        remarks: feedbackData['remarks'].toString(),
        createdAt: DateTime.now(),
      );

      await ref.read(feedbackRepositoryProvider).saveFeedback(newFeedback);

      final paymentChannel =
          appt.paymentMethod == PaymentMethod.credit
              ? PaymentChannel.credit
              : PaymentChannel.stripe;

      await ref
          .read(appointmentNotifierProvider.notifier)
          .updateStatus(appt.id, AppointmentStatus.completed, paymentChannel);

      ref.invalidate(authNotifierProvider);

      final currentCompletedCount = currentUser.completedSessionsCount;
      final baseSessionAmount =
          appt.amount > 0 ? appt.amount : (appt.duration / 60) * 80.0;

      final transportFee = appt.transportFee;

      final earningsData = CommissionService.calculateEarnings(
        sessionAmount: baseSessionAmount,
        transportFee: transportFee,
        completedSessions: currentCompletedCount,
      );

      final amountToEarn = earningsData['trainerEarning'] as double;
      final takeRateStr = earningsData['takeRatePercentage'] as String;

      AppSnackBar.success(
        context,
        'Session completed! RM ${amountToEarn.toStringAsFixed(2)} (after $takeRateStr platform fee) added to your wallet.',
      );
      context.router.maybePop();
    } catch (e) {
      AppSnackBar.error(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRateReview(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appt,
  ) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RateReviewBottomSheet(),
    );

    if (result == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(feedbackRepositoryProvider)
          .updateParentReview(
            appointmentId: appt.id,
            rating: result['rating'] as int,
            review: result['review'] as String,
          );

      if (context.mounted) {
        AppSnackBar.success(context, 'Thank you for your review!');
        setState(() {
          _cachedFeedback = _cachedFeedback?.copyWith(
            rating: result['rating'] as int,
            review: result['review'] as String,
          );
        });
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, e.toString());
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
