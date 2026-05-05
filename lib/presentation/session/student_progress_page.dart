import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/feedback/feedback_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/child_model.dart';
import '../../../domain/models/feedback_model.dart';
import '../shared/user_avatar.dart';

@RoutePage()
class StudentProgressPage extends ConsumerWidget {
  const StudentProgressPage({required this.student, super.key});
  final ChildModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbacksAsync = ref.watch(studentFeedbacksProvider(student.id));

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Performance Tracking',
          style: AppWidget.h3TextFieldStyle(),
        ),
      ),
      body: feedbacksAsync.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: ThemeColor.darkBlue),
            ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (feedbacks) {
          if (feedbacks.isEmpty) {
            return _buildEmptyState();
          }

          double totalFocus = 0;
          double totalEnergy = 0;
          for (final fb in feedbacks) {
            totalFocus += fb.focusLevel;
            totalEnergy += fb.energyLevel;
          }
          final avgFocus = totalFocus / feedbacks.length;
          final avgEnergy = totalEnergy / feedbacks.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStudentHeader(),
                24.heightBox,

                Text('Overall Average', style: AppWidget.h3TextFieldStyle()),
                12.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Avg Focus',
                        avgFocus,
                        Icons.psychology,
                      ),
                    ),
                    16.widthBox,
                    Expanded(
                      child: _buildStatCard(
                        'Avg Energy',
                        avgEnergy,
                        Icons.bolt,
                      ),
                    ),
                  ],
                ),
                32.heightBox,

                Text('Session History', style: AppWidget.h3TextFieldStyle()),
                12.heightBox,
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: feedbacks.length,
                  separatorBuilder: (context, index) => 16.heightBox,
                  itemBuilder: (context, index) {
                    return _buildFeedbackItem(feedbacks[index]);
                  },
                ),
                40.heightBox,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStudentHeader(),
          40.heightBox,
          const Icon(
            Icons.analytics_outlined,
            size: 64,
            color: ThemeColor.lightGrey,
          ),
          16.heightBox,
          Text(
            'No performance records yet.',
            style: AppWidget.bodyLarge().copyWith(color: ThemeColor.grey100),
          ),
          8.heightBox,
          Text(
            'Complete a session to log feedback.',
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentHeader() {
    final genderText =
        (student.gender != null && student.gender!.isNotEmpty)
            ? ', ${student.gender}'
            : '';

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
      child: Row(
        children: [
          UserAvatar(
            radius: 30,
            username: student.name,
            userAvatarUrl: student.userAvatarUrl,
          ),
          16.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: AppWidget.h2TextFieldStyle(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                4.heightBox,
                Text(
                  '${student.age} years old$genderText',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                if (student.specialNeeds.isNotEmpty) ...[
                  8.heightBox,
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        student.specialNeeds
                            .map(
                              (need) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeColor.orange.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  need,
                                  style: AppWidget.bodyExtraSmall().copyWith(
                                    color: ThemeColor.orange,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, double value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.darkBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ThemeColor.white, size: 24),
          12.heightBox,
          Text(
            title,
            style: AppWidget.bodySmall().copyWith(
              color: ThemeColor.white.withValues(alpha: 0.8),
            ),
          ),
          4.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: AppWidget.h1TextFieldStyle().copyWith(
                  color: ThemeColor.white,
                  fontSize: 28,
                ),
              ),
              Text(
                '/5',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          12.heightBox,
          LinearProgressIndicator(
            value: value / 5.0,
            backgroundColor: ThemeColor.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              value >= 4.0
                  ? ThemeColor.green
                  : (value >= 2.5 ? ThemeColor.orange : Colors.red),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(FeedbackModel fb) {
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(fb.createdAt);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.check_circle, color: ThemeColor.green, size: 16),
            ],
          ),
          12.heightBox,
          Row(
            children: [
              _buildMiniScore('Focus', fb.focusLevel),
              16.widthBox,
              _buildMiniScore('Energy', fb.energyLevel),
            ],
          ),
          12.heightBox,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeColor.cream,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              fb.remarks,
              style: AppWidget.bodyMedium().copyWith(color: ThemeColor.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniScore(String label, int score) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
        ),
        Text(
          '$score/5',
          style: AppWidget.bodySmall().copyWith(
            fontWeight: FontWeight.bold,
            color: ThemeColor.darkBlue,
          ),
        ),
      ],
    );
  }
}
