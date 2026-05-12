import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/user/trainer_provider.dart';
import '../../../application/user/trainer_student_ui_model.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../shared/curved_header_background.dart';
import '../../shared/user_avatar.dart';
import '../shared/stat_item.dart';

class TrainerMyStudentsPage extends ConsumerStatefulWidget {
  const TrainerMyStudentsPage({super.key});

  @override
  ConsumerState<TrainerMyStudentsPage> createState() =>
      _TrainerMyStudentsPageState();
}

class _TrainerMyStudentsPageState extends ConsumerState<TrainerMyStudentsPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(trainerStudentsProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      // 🚀 2. 处理异步数据的不同状态
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) =>
                Center(child: Text(context.l10n.errorMessage(err.toString()))),
        data: (allStudents) {
          // 🚀 3. 动态计算 Summary 卡片的数据
          final activeStudents =
              allStudents.where((s) => s.status == 'active').toList();
          final pendingStudents =
              allStudents.where((s) => s.status == 'pending').toList();
          final pastStudents =
              allStudents.where((s) => s.status == 'past').toList();

          // 🚀 4. 根据当前选中的 Tab 获取要在列表里渲染的学生
          final List<TrainerStudentUIModel> filteredStudents;
          if (_currentTabIndex == 0) {
            filteredStudents = activeStudents.cast<TrainerStudentUIModel>();
          } else if (_currentTabIndex == 1) {
            filteredStudents = pendingStudents.cast<TrainerStudentUIModel>();
          } else {
            filteredStudents = pastStudents.cast<TrainerStudentUIModel>();
          }

          return SingleChildScrollView(
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
                        Text(
                          context.l10n.myStudentsTitle,
                          style: AppWidget.h1TextFieldStyle(),
                        ),
                        24.heightBox,

                        // 🚀 5. 使用真实数据渲染 Summary 卡片
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
                              Text(
                                context.l10n.summaryTitle,
                                style: AppWidget.h3TextFieldStyle(),
                              ),
                              16.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                    child: StatItem(
                                      label: context.l10n.totalStudentsLabel,
                                      value: allStudents.length.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: StatItem(
                                      label: context.l10n.activeSessionsLabel,
                                      value: activeStudents.length.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: StatItem(
                                      label: context.l10n.pendingRequestsLabel,
                                      value: pendingStudents.length.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        32.heightBox,

                        _buildCustomTabBar(),
                        24.heightBox,

                        if (filteredStudents.isEmpty)
                          _currentTabIndex == 0
                              ? _buildEmptyState(
                                context.l10n.noActiveStudentsTitle,
                                context.l10n.noActiveStudentsDesc,
                                Icons.people_outline_rounded,
                              )
                              : _currentTabIndex == 1
                              ? _buildEmptyState(
                                context.l10n.noPendingRequestsTitle,
                                context.l10n.noPendingStudentRequestsDesc,
                                Icons.inbox_rounded,
                              )
                              : _buildEmptyState(
                                context.l10n.noPastStudentsTitle,
                                context.l10n.noPastStudentsDesc,
                                Icons.history_rounded,
                              )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredStudents.length,
                            separatorBuilder: (context, index) => 16.heightBox,
                            itemBuilder: (context, index) {
                              final studentData = filteredStudents[index];
                              return _buildStudentCard(studentData);
                            },
                          ),

                        40.heightBox,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeColor.lightGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTabItem(context.l10n.tabActive, 0),
          _buildTabItem(context.l10n.tabPending, 1),
          _buildTabItem(context.l10n.tabPast, 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _currentTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ThemeColor.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: ThemeColor.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            title,
            style: AppWidget.bodyMedium().copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? ThemeColor.darkBlue : ThemeColor.grey100,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(TrainerStudentUIModel data) {
    final child = data.child;
    final name = child.name;
    final age = child.age;
    final specialNeeds = child.specialNeeds;
    final avatarUrl = child.userAvatarUrl;

    final booking = data.latestBooking;
    final parentName = booking.parentName;
    final sport = booking.sport;

    final status = data.status;

    final hasPendingBooking = data.hasPendingBooking;

    final lastSession = '-'; // 你可以之后从 booking.dateTime 转换格式
    final progressPercent = 0.5; // TODO: 你的进度条逻辑
    final hasNotification = hasPendingBooking;
    final sportIcon = getSportIcon(sport);

    String primaryButtonText;
    if (status == 'pending') {
      primaryButtonText = context.l10n.acceptRequestAction;
    } else if (status == 'active') {
      primaryButtonText =
          hasPendingBooking
              ? context.l10n.reviewNewRequestAction
              : context.l10n.logProgressAction;
    } else {
      primaryButtonText = context.l10n.viewHistoryAction;
    }

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
              UserAvatar(radius: 26, userAvatarUrl: avatarUrl, username: name),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$name ${context.l10n.childAgeFormat(age.toString())}',
                            style: AppWidget.bodyLarge().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    2.heightBox,
                    Text(
                      context.l10n.parentNameLabel(parentName),
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    6.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              sportIcon,
                              size: 14,
                              color: ThemeColor.grey100,
                            ),
                            4.widthBox,
                            Text(
                              sport.toLocalizedSport(context),
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
                              ),
                            ),
                          ],
                        ),
                        if (status == 'active')
                          Text(
                            context.l10n.lastSessionLabel(lastSession),
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

          12.heightBox,
          if (specialNeeds.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  specialNeeds.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.lightOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: AppWidget.bodyExtraSmall().copyWith(
                          color: ThemeColor.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
            ),

          if (status == 'active') ...[
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
          ],

          //TODO: 有新的request时，active student 的sport会变成最新的
          20.heightBox,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.pushRoute(StudentProgressRoute(student: child));
                  },
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
                      status == 'pending'
                          ? context.l10n.messageParentAction
                          : context.l10n.viewPerformanceAction,
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
                          color:
                              (status == 'pending' ||
                                      (status == 'active' && hasPendingBooking))
                                  ? ThemeColor.green
                                  : ThemeColor.darkBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          primaryButtonText,
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

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: ThemeColor.grey100.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColor.aquaBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: ThemeColor.darkBlue),
          ),
          16.heightBox,
          Text(
            title,
            style: AppWidget.bodyLarge().copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeColor.darkBlue,
            ),
          ),
          8.heightBox,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }
}
