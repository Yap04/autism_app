import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import 'widgets/admin_side_menu.dart';

@RoutePage()
class AdminLayoutPage extends ConsumerWidget {
  const AdminLayoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter(
      routes: const [
        AdminDashboardRoute(),
        AdminVerificationRoute(),
        AdminAppointmentsRoute(),
        AdminTransactionsRoute(),
        AdminUsersRoute(),
        AdminContentRoute(),
        AdminSupportRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          backgroundColor: ThemeColor.cream,
          body: Row(
            children: [
              AdminSideMenu(tabsRouter: tabsRouter),

              Expanded(
                child: Column(
                  children: [
                    _buildAdminAppBar(context, ref),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminAppBar(BuildContext context, WidgetRef ref) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        border: Border(
          bottom: BorderSide(
            color: ThemeColor.lightGrey.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),

          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: ThemeColor.darkBlue,
                ),
                onPressed: () {
                  // TODO: 查看后台通知
                },
              ),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ThemeColor.cream,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: ThemeColor.darkBlue,
                      child: Icon(
                        Icons.shield,
                        color: ThemeColor.white,
                        size: 16,
                      ),
                    ),
                    12.widthBox,
                    Text(
                      'Super Admin',
                      style: AppWidget.bodyMedium().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.widthBox,
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: ThemeColor.grey100,
                      size: 20,
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
