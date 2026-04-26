import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/auth/auth_notifier.dart';
import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';
import '../../../../core/extension/widget_ext.dart';
import '../../../../core/routes/app_router.dart';

class AdminSideMenu extends ConsumerWidget {
  const AdminSideMenu({required this.tabsRouter, super.key});
  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 260,
      color: ThemeColor.darkBlue,
      child: Column(
        children: [
          Container(
            height: 80,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ThemeColor.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.sports_basketball,
                  color: ThemeColor.orange,
                  size: 28,
                ),
                12.widthBox,
                Text(
                  'Autism Sports',
                  style: AppWidget.h3TextFieldStyle().copyWith(
                    color: ThemeColor.white,
                  ),
                ),
              ],
            ),
          ),

          24.heightBox,
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.grid_view_rounded,
                  title: 'Dashboard',
                  index: 0,
                ),
                _buildMenuItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Verification',
                  index: 1,
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today_rounded,
                  title: 'Appointments',
                  index: 2,
                ),
                _buildMenuItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'Transactions',
                  index: 3,
                ),
                _buildMenuItem(
                  icon: Icons.people_outline_rounded,
                  title: 'Users',
                  index: 4,
                ),
                _buildMenuItem(
                  icon: Icons.my_library_books_rounded,
                  title: 'Content',
                  index: 5,
                ),
                _buildMenuItem(
                  icon: Icons.support_agent_rounded,
                  title: 'Support',
                  index: 6,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: ThemeColor.white.withValues(alpha: 0.1)),
              ),
            ),
            child: InkWell(
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  context.router.replaceAll([const LoginRoute()]);
                }
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    color: ThemeColor.white,
                    size: 22,
                  ),
                  12.widthBox,
                  Text(
                    'Log Out',
                    style: AppWidget.bodyLarge().copyWith(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected =
        tabsRouter.pageCount > index && tabsRouter.activeIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (tabsRouter.pageCount > index) {
            tabsRouter.setActiveIndex(index);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? ThemeColor.white.withValues(alpha: 0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? ThemeColor.white.withValues(alpha: 0.2)
                      : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? ThemeColor.white : ThemeColor.grey100,
                size: 22,
              ),
              16.widthBox,
              Text(
                title,
                style: AppWidget.bodyLarge().copyWith(
                  color: isSelected ? ThemeColor.white : ThemeColor.grey100,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
