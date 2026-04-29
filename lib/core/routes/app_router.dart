import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/ticket_model.dart';
import '../../presentation/admin/appointment/admin_appointments_page.dart';
import '../../presentation/admin/content/admin_content_editor_page.dart';
import '../../presentation/admin/content/admin_content_page.dart';
import '../../presentation/admin/dashboard/admin_dashboard_page.dart';
import '../../presentation/admin/layout/admin_layout_page.dart';
import '../../presentation/admin/support/admin_support_page.dart';
import '../../presentation/admin/transactions/admin_transactions_page.dart';
import '../../presentation/admin/users/admin_users_page.dart';
import '../../presentation/admin/verification/admin_verification_page.dart';
import '../../presentation/auth/login_page.dart';
import '../../presentation/auth/signup_page.dart';
import '../../presentation/auth/splash_page.dart';
import '../../presentation/chat/chat_list_page.dart';
import '../../presentation/chat/chat_page.dart';
import '../../presentation/parent/appointment/booking_details_page.dart';
import '../../presentation/parent/appointment/trainer_list_page.dart';
import '../../presentation/parent/home/content/content_list_page.dart';
import '../../presentation/parent/home/parent_progress_page.dart';
import '../../presentation/parent/parent_bottom_nav_page.dart';
import '../../presentation/profile/dashboard/map_picker_page.dart';
import '../../presentation/profile/dashboard/trainer_dashboard_page.dart';
import '../../presentation/profile/edit_profile_page.dart';
import '../../presentation/profile/profile_page.dart';
import '../../presentation/profile/support/create_ticket_page.dart';
import '../../presentation/profile/support/support_page.dart';
import '../../presentation/profile/support/ticket_chat_page.dart';
import '../../presentation/profile/wallet/all_transactions_page.dart';
import '../../presentation/profile/wallet/wallet_page.dart';
import '../../presentation/trainer/trainer_bottom_nav_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignupRoute.page),
    AutoRoute(page: ParentBottomNavRoute.page),
    AutoRoute(page: TrainerBottomNavRoute.page),
    AutoRoute(page: BookingDetailsRoute.page),
    AutoRoute(page: ParentProgressRoute.page),
    AutoRoute(page: EditProfileRoute.page),
    AutoRoute(page: TrainerListRoute.page),
    AutoRoute(page: TrainerDashboardRoute.page),
    AutoRoute(page: MapPickerRoute.page),
    AutoRoute(page: WalletRoute.page),
    AutoRoute(page: ChatRoute.page),
    AutoRoute(page: AllTransactionsRoute.page),
    AutoRoute(page: ContentListRoute.page),
    AutoRoute(page: SupportRoute.page),
    AutoRoute(page: CreateTicketRoute.page),
    AutoRoute(page: TicketChatRoute.page),

    // Admin Web Panel Routes
    AutoRoute(
      page: AdminLayoutRoute.page,
      // initial: true,
      children: [
        AutoRoute(page: AdminDashboardRoute.page),
        AutoRoute(page: AdminVerificationRoute.page),
        AutoRoute(page: AdminAppointmentsRoute.page),
        AutoRoute(page: AdminTransactionsRoute.page),
        AutoRoute(page: AdminUsersRoute.page),
        AutoRoute(page: AdminContentRoute.page),
        AutoRoute(page: AdminSupportRoute.page),
      ],
    ),
    AutoRoute(page: AdminContentEditorRoute.page),
  ];
}
