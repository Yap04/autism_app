import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';
import 'shared/stat_item.dart';

// 临时假数据模型，方便你日后替换为真实的 Firestore Model
class _TempStudentData {
  final String name;
  final int age;
  final String parentName;
  final String sport;
  final IconData icon;
  final String lastSession;
  final String rating;
  final double progressPercent;
  final bool hasNotification;
  final List<String> specialNeeds; // 新增：特殊需求标签
  final String status; // active, pending, past

  _TempStudentData({
    required this.name,
    required this.age,
    required this.parentName,
    required this.sport,
    required this.icon,
    required this.lastSession,
    required this.rating,
    required this.progressPercent,
    required this.hasNotification,
    required this.specialNeeds,
    required this.status,
  });
}

class TrainerMyStudentsPage extends StatefulWidget {
  const TrainerMyStudentsPage({super.key});

  @override
  State<TrainerMyStudentsPage> createState() => _TrainerMyStudentsPageState();
}

class _TrainerMyStudentsPageState extends State<TrainerMyStudentsPage> {
  int _currentTabIndex = 0; // 0: Active, 1: Pending, 2: Past

  // 模拟从数据库拉取的学生列表
  final List<_TempStudentData> _allStudents = [
    _TempStudentData(
      name: 'Ahmad',
      age: 8,
      parentName: 'Mrs. Siti',
      sport: 'Swimming',
      icon: Icons.pool,
      lastSession: '11 Mac',
      rating: '4.9',
      progressPercent: 0.6,
      hasNotification: true,
      specialNeeds: ['ASD Level 1', 'Non-verbal'],
      status: 'active',
    ),
    _TempStudentData(
      name: 'Maya',
      age: 10,
      parentName: 'Mr. John',
      sport: 'Gymnastics',
      icon: Icons.sports_gymnastics,
      lastSession: '11 Mac',
      rating: '4.8',
      progressPercent: 0.4,
      hasNotification: false,
      specialNeeds: ['ADHD', 'Loves high-fives'],
      status: 'active',
    ),
    _TempStudentData(
      name: 'Leo',
      age: 7,
      parentName: 'Sarah Wong',
      sport: 'Basketball',
      icon: Icons.sports_basketball,
      lastSession: '-',
      rating: 'New',
      progressPercent: 0.0,
      hasNotification: true,
      specialNeeds: ['Sensory sensitive'],
      status: 'pending',
    ),
    _TempStudentData(
      name: 'Adam',
      age: 12,
      parentName: 'Mr. Lee',
      sport: 'Swimming',
      icon: Icons.pool,
      lastSession: '2 Feb',
      rating: '5.0',
      progressPercent: 1.0,
      hasNotification: false,
      specialNeeds: ['ASD Level 2'],
      status: 'past',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 根据 Tab 过滤学生
    final filteredStudents =
        _allStudents.where((student) {
          if (_currentTabIndex == 0) return student.status == 'active';
          if (_currentTabIndex == 1) return student.status == 'pending';
          return student.status == 'past';
        }).toList();

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
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
                    Text('My Students', style: AppWidget.h1TextFieldStyle()),
                    24.heightBox,

                    // 保留的 Summary 卡片
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
                          Text('Summary', style: AppWidget.h3TextFieldStyle()),
                          16.heightBox,
                          const Row(
                            children: [
                              Expanded(
                                child: StatItem(
                                  label: 'Total\nStudents',
                                  value: '12',
                                ),
                              ),
                              Expanded(
                                child: StatItem(
                                  label: 'Active\nSessions',
                                  value: '8',
                                ),
                              ),
                              Expanded(
                                child: StatItem(
                                  label: 'Pending\nRequests',
                                  value: '2',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    32.heightBox,

                    // 🚀 新增：自定义 Tab 切换栏
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
                          final student = filteredStudents[index];
                          return _buildStudentCard(student);
                        },
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

  // 构建自定义 TabBar
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
  Widget _buildStudentCard(_TempStudentData student) {
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
              const CircleAvatar(
                radius: 26,
                backgroundColor: ThemeColor.grey100,
                child: Icon(Icons.person, color: ThemeColor.white, size: 32),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 学生名字与评分
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${student.name} (${student.age}y)',
                          style: AppWidget.bodyLarge().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (student.status == 'active')
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: ThemeColor.lightOrange,
                                size: 16,
                              ),
                              4.widthBox,
                              Text(
                                student.rating,
                                style: AppWidget.bodyMedium().copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    2.heightBox,
                    // 家长标签
                    Text(
                      'Parent: ${student.parentName}',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    6.heightBox,
                    // 运动与最新进度
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              student.icon,
                              size: 14,
                              color: ThemeColor.grey100,
                            ),
                            4.widthBox,
                            Text(
                              student.sport,
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
                              ),
                            ),
                          ],
                        ),
                        if (student.status == 'active')
                          Text(
                            'Last: ${student.lastSession}',
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
          // 🚀 核心新增：特殊需求标签栏 (Autism-specific feature)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                student.specialNeeds.map((tag) {
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

          if (student.status == 'active') ...[
            16.heightBox,
            // 进度条
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
                  widthFactor: student.progressPercent,
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

          20.heightBox,
          // 底部操作按钮群
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
                      student.status == 'pending'
                          ? 'Message Parent'
                          : 'View Profile',
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
                              student.status == 'pending'
                                  ? ThemeColor.green
                                  : ThemeColor.darkBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.status == 'pending'
                              ? 'Accept Request'
                              : 'Log Progress',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (student.hasNotification)
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
