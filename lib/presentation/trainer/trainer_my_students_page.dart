import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/user/trainer_provider.dart';
import '../../application/user/trainer_student_ui_model.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/sport_ext.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';
import '../shared/user_avatar.dart';
import 'shared/stat_item.dart';

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
        error: (err, stack) => Center(child: Text('Error: $err')),
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
                          'My Students',
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
                                'Summary',
                                style: AppWidget.h3TextFieldStyle(),
                              ),
                              16.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                    child: StatItem(
                                      label: 'Total\nStudents',
                                      value: allStudents.length.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: StatItem(
                                      label: 'Active\nSessions',
                                      value: activeStudents.length.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: StatItem(
                                      label: 'Pending\nRequests',
                                      value: pendingStudents.length.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        32.heightBox,

                        // 自定义 Tab 切换栏
                        _buildCustomTabBar(),
                        24.heightBox,

                        // 动态渲染学生列表
                        if (filteredStudents.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                'No students found.',
                                style: AppWidget.bodyMedium().copyWith(
                                  color: ThemeColor.grey100,
                                ),
                              ),
                            ),
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
          _buildTabItem('Active', 0),
          _buildTabItem('Pending', 1),
          _buildTabItem('Past', 2),
        ],
      ),
    );
  }

  // 构建单个 Tab 按钮
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

  // 升级后的学生卡片
  Widget _buildStudentCard(TrainerStudentUIModel data) {
    final child = data.child;
    final name = child.name;
    final age = child.age;
    final specialNeeds = child.specialNeeds;
    final avatarUrl = child.userAvatarUrl;

    // 从 booking 对象里取订单资料
    final booking = data.latestBooking;
    final parentName = booking.parentName;
    final sport = booking.sport;

    // 你算好的 Tab 状态
    final status = data.status;

    final hasPendingBooking = data.hasPendingBooking;

    final rating = 'New';
    final lastSession = '-'; // 你可以之后从 booking.dateTime 转换格式
    final progressPercent = 0.5; // TODO: 你的进度条逻辑
    final hasNotification = hasPendingBooking;
    final sportIcon = getSportIcon(sport);

    String primaryButtonText;
    if (status == 'pending') {
      primaryButtonText = 'Accept Request';
    } else if (status == 'active') {
      primaryButtonText =
          hasPendingBooking ? 'Review New Request' : 'Log Progress';
    } else {
      primaryButtonText = 'View History';
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
                            '$name (${age}y)',
                            style: AppWidget.bodyLarge().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (status == 'active')
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
                    2.heightBox,
                    Text(
                      'Parent: $parentName',
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
                              sport,
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
                              ),
                            ),
                          ],
                        ),
                        if (status == 'active')
                          Text(
                            'Last: $lastSession',
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
                      status == 'pending' ? 'Message Parent' : 'View Profile',
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
}

// 构建自定义 TabBar
