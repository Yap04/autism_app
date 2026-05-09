import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/child/child_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/appointment_model.dart';
import '../../../domain/models/child_model.dart';
import '../../shared/user_avatar.dart';

@RoutePage()
class ManageChildrenPage extends ConsumerWidget {
  const ManageChildrenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(userChildrenProvider);
    final appointmentsAsync = ref.watch(appointmentNotifierProvider);
    final allAppointments = appointmentsAsync.valueOrNull ?? [];

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
                            return _buildChildCard(
                              context,
                              child,
                              allAppointments,
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () => context.pushRoute(AddChildrenRoute()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: ThemeColor.darkBlue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: ThemeColor.darkBlue.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: ThemeColor.white),
              8.widthBox,
              Text(
                'Add Child',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(
    BuildContext context,
    ChildModel child,
    List<AppointmentModel> allAppointments,
  ) {
    final name = child.name;
    final age = child.age;
    final gender = child.gender;
    final specialNeeds = child.specialNeeds;
    final avatarUrl = child.userAvatarUrl;

    final now = DateTime.now();
    final activeTrainersCount =
        allAppointments
            .where(
              (app) =>
                  app.childId == child.id &&
                  app.status == AppointmentStatus.accepted &&
                  app.dateTime.isAfter(now),
            )
            .map((app) => app.trainerId)
            .toSet()
            .length;

    return GestureDetector(
      onTap: () => context.pushRoute(StudentProgressRoute(student: child)),
      child: Container(
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
                UserAvatar(
                  radius: 28,
                  userAvatarUrl: avatarUrl,
                  username: name,
                ),
                16.widthBox,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppWidget.h3TextFieldStyle(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
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
                          Icon(
                            Icons.sports,
                            size: 14,
                            color:
                                activeTrainersCount > 0
                                    ? ThemeColor.orange
                                    : ThemeColor.grey100,
                          ),
                          4.widthBox,
                          Text(
                            '$activeTrainersCount Active Trainer${activeTrainersCount == 1 ? '' : 's'}',
                            style: AppWidget.bodyExtraSmall().copyWith(
                              color:
                                  activeTrainersCount > 0
                                      ? ThemeColor.orange
                                      : ThemeColor.grey100,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    context.pushRoute(AddChildrenRoute(child: child));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColor.darkBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 20,
                      color: ThemeColor.white,
                    ),
                  ),
                ),
              ],
            ),

            16.heightBox,
            const Divider(height: 1),
            12.heightBox,

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
                            color: ThemeColor.lightOrange.withValues(
                              alpha: 0.3,
                            ),
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
            16.heightBox,
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Performance History',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: ThemeColor.darkBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
