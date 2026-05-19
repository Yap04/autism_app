import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/color_constant.dart';
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
        AdminFeesRoute(),
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
}
