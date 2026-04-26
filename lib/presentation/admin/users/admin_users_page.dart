import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/admin/user/admin_user_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersStreamProvider);
    final currentFilter = ref.watch(userRoleFilterProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Management', style: AppWidget.h2TextFieldStyle()),
          8.heightBox,
          Text(
            'Manage parents and trainers, and monitor account statuses.',
            style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
          ),

          32.heightBox,

          usersAsync.when(
            data: (users) {
              final filteredList =
                  users.where((u) {
                    if (currentFilter == 'All') return true;
                    return u.role.name.toLowerCase() ==
                        currentFilter.toLowerCase();
                  }).toList();

              return Column(
                children: [
                  _buildStatOverview(users),
                  32.heightBox,
                  _buildFilterTabs(ref, currentFilter),
                  24.heightBox,

                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTableHeader(),
                        const Divider(height: 1),
                        if (filteredList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('No users found.'),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            separatorBuilder:
                                (context, index) => const Divider(height: 1),
                            itemBuilder:
                                (context, index) => _buildUserRow(
                                  context,
                                  ref,
                                  filteredList[index],
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading:
                () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(
                      color: ThemeColor.darkBlue,
                    ),
                  ),
                ),
            error:
                (err, stack) => Center(
                  child: Text(
                    'Failed to load users: $err',
                    style: AppWidget.bodyMedium().copyWith(color: Colors.red),
                  ),
                ),
          ),

          48.heightBox,
        ],
      ),
    );
  }

  Widget _buildStatOverview(List<UserModel> users) {
    final totalParents = users.where((u) => u.role == UserRole.parent).length;
    final totalTrainers = users.where((u) => u.role == UserRole.trainer).length;
    final suspendedCount =
        users.where((u) => u.status == UserStatus.suspended).length;

    return Row(
      children: [
        _buildStatCard(
          'Total Parents',
          '$totalParents',
          Icons.family_restroom,
          Colors.blue,
        ),
        24.widthBox,
        _buildStatCard(
          'Active Trainers',
          '$totalTrainers',
          Icons.sports,
          ThemeColor.orange,
        ),
        24.widthBox,
        _buildStatCard(
          'Suspended Accounts',
          '$suspendedCount',
          Icons.gavel_rounded,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            20.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                Text(value, style: AppWidget.h3TextFieldStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(WidgetRef ref, String activeFilter) {
    final filters = ['All', 'parent', 'trainer'];
    return Row(
      children:
          filters.map((f) {
            final isSelected = activeFilter == f;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap:
                    () => ref.read(userRoleFilterProvider.notifier).state = f,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? ThemeColor.darkBlue : ThemeColor.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color:
                          isSelected
                              ? ThemeColor.darkBlue
                              : ThemeColor.lightGrey,
                    ),
                  ),
                  child: Text(
                    f.toUpperCase(),
                    style: AppWidget.bodySmall().copyWith(
                      color: isSelected ? ThemeColor.white : ThemeColor.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: ThemeColor.cream.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('User Info', style: _headerStyle())),
          Expanded(child: Text('Role', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Joined Date', style: _headerStyle())),
          Expanded(child: Text('Status', style: _headerStyle())),
          Expanded(
            child: Text(
              'Action',
              style: _headerStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => AppWidget.bodySmall().copyWith(
    fontWeight: FontWeight.bold,
    color: ThemeColor.grey100,
  );

  Widget _buildUserRow(BuildContext context, WidgetRef ref, UserModel user) {
    final displayName = user.name ?? user.nickname ?? 'Unknown';
    final userEmail = user.email;
    final joinDate = user.createdAt ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ThemeColor.lightGrey,
                  child: Text(
                    displayName.isNotEmpty
                        ? displayName.substring(0, 1).toUpperCase()
                        : 'U',
                    style: const TextStyle(color: ThemeColor.darkBlue),
                  ),
                ),
                16.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        userEmail,
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
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      user.role == UserRole.trainer
                          ? ThemeColor.orange.withValues(alpha: 0.1)
                          : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  user.role.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color:
                        user.role == UserRole.trainer
                            ? ThemeColor.orange
                            : Colors.blue,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              DateFormat('dd MMM yyyy').format(joinDate),
              style: AppWidget.bodyMedium(),
            ),
          ),

          Expanded(child: _buildStatusTag(user.status)),

          Expanded(child: Align(child: _buildActionBtn(context, ref, user))),
        ],
      ),
    );
  }

  Widget _buildStatusTag(UserStatus status) {
    final isActive = status == UserStatus.active;
    final color = isActive ? Colors.green : Colors.red;
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: color),
        6.widthBox,
        Text(
          status.name.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, WidgetRef ref, UserModel user) {
    final isActive = user.status == UserStatus.active;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _confirmToggleStatus(context, ref, user),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: isActive ? Colors.red : Colors.green),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isActive ? 'Suspend' : 'Activate',
            style: AppWidget.bodySmall().copyWith(
              color: isActive ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _confirmToggleStatus(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    final isActive = user.status == UserStatus.active;
    final action = isActive ? 'suspend' : 'activate';
    final displayName = user.name ?? user.nickname ?? 'this user';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('${isActive ? 'Suspend' : 'Activate'} User?'),
            content: Text('Are you sure you want to $action $displayName?'),
            actions: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Cancel', style: AppWidget.bodyMedium()),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      final newStatus =
                          isActive ? UserStatus.suspended : UserStatus.active;

                      await ref
                          .read(userRepositoryProvider)
                          .updateUserStatus(user.id, newStatus);

                      if (context.mounted) {
                        Navigator.pop(context);
                        AppSnackBar.success(
                          context,
                          'User account ${action}d successfully.',
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppSnackBar.error(context, 'Failed to update user: $e');
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Confirm',
                      style: AppWidget.bodyMedium().copyWith(
                        color: Colors.white,
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
}
