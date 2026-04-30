import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';

// import '../../../domain/models/child_model.dart'; // 请确保导入你刚刚生成的 ChildModel

// ==========================================
// 🚀 1. 临时假数据 Provider (日后替换为真实的 Firestore 抓取)
// ==========================================
final mockChildrenProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 800)); // 模拟网络延迟
  return [
    {
      'id': 'c1',
      'name': 'Leo',
      'age': 8,
      'gender': 'Male',
      'specialNeeds': ['ASD Level 1', 'Non-verbal'],
      'assignedTrainers': 1,
    },
    {
      'id': 'c2',
      'name': 'Mia',
      'age': 6,
      'gender': 'Female',
      'specialNeeds': ['Sensory sensitive'],
      'assignedTrainers': 0,
    },
  ];
});

// ==========================================
// 🚀 2. Manage Children 主页面
// ==========================================
@RoutePage()
class ManageChildrenPage extends ConsumerWidget {
  const ManageChildrenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(mockChildrenProvider); // 换成真实的 provider

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        centerTitle: true,
        title: Text('Manage Children', style: AppWidget.h2TextFieldStyle()),
      ),
      body: childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (children) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Text(
                  "Manage your children's profiles here. Accurate special needs tags help our trainers provide the best care.",
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ),

              Expanded(
                child:
                    children.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: children.length,
                          separatorBuilder: (context, index) => 16.heightBox,
                          itemBuilder: (context, index) {
                            final child = children[index];
                            return _buildChildCard(context, child);
                          },
                        ),
              ),
            ],
          );
        },
      ),
      // 🚀 悬浮添加按钮
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushRoute(const AddChildrenRoute());
        },
        backgroundColor: ThemeColor.darkBlue,
        icon: const Icon(Icons.add, color: ThemeColor.white),
        label: Text(
          'Add Child',
          style: AppWidget.bodyMedium().copyWith(
            color: ThemeColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, Map<String, dynamic> child) {
    final name = child['name'] as String? ?? 'Unknown';
    final age = child['age'] as int? ?? 0;
    final gender = child['gender'] as String? ?? 'Unknown';
    final assignedTrainers = child['assignedTrainers'] as int? ?? 0;

    final specialNeeds = List<String>.from(
      child['specialNeeds'] as Iterable<dynamic>? ?? [],
    );

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
              // 头像
              CircleAvatar(
                radius: 28,
                backgroundColor: ThemeColor.blue.withValues(alpha: 0.1),
                child: Text(
                  // 修复 1: 现在 name 已经是 String 类型了，可以使用 [0]
                  // 加入 isNotEmpty 判断以防空字符串导致越界崩溃
                  name.isNotEmpty ? name[0] : '?',
                  style: AppWidget.h2TextFieldStyle().copyWith(
                    color: ThemeColor.darkBlue,
                  ),
                ),
              ),
              16.widthBox,

              // 基础信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 修复 2: 传入确定为 String 类型的 name 变量
                    Text(name, style: AppWidget.h3TextFieldStyle()),
                    4.heightBox,
                    Text(
                      '$age years old • $gender',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    8.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.sports,
                          size: 14,
                          color: ThemeColor.orange,
                        ),
                        4.widthBox,
                        Text(
                          '$assignedTrainers Active Trainers',
                          style: AppWidget.bodyExtraSmall().copyWith(
                            color: ThemeColor.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 编辑按钮
              IconButton(
                onPressed: () {
                  // TODO: 跳转到 Edit Child 页面
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: ThemeColor.grey100,
                ),
                tooltip: 'Edit Profile',
              ),
            ],
          ),

          16.heightBox,
          const Divider(height: 1),
          12.heightBox,

          // 标签区域 (Autism/Special Needs)
          Text(
            'Special Needs & Tags',
            style: AppWidget.bodyExtraSmall().copyWith(
              color: ThemeColor.grey100,
              fontWeight: FontWeight.bold,
            ),
          ),
          8.heightBox,
          if (specialNeeds.isEmpty)
            Text(
              'No tags added.',
              style: AppWidget.bodySmall().copyWith(
                fontStyle: FontStyle.italic,
                color: ThemeColor.grey100,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  specialNeeds.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.lightOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ThemeColor.lightOrange.withValues(alpha: 0.3),
                        ),
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
        ],
      ),
    );
  }

  // ==========================================
  // 🚀 4. 空状态 UI (当家长还没添加任何孩子时)
  // ==========================================
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: ThemeColor.blue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.child_care_rounded,
            size: 60,
            color: ThemeColor.darkBlue,
          ),
        ),
        24.heightBox,
        Text('No Children Added Yet', style: AppWidget.h3TextFieldStyle()),
        12.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Add your child's profile to start booking specialized training sessions with certified coaches.",
            textAlign: TextAlign.center,
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),
        ),
      ],
    );
  }
}
