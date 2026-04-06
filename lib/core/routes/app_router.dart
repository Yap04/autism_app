import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../presentation/auth/login_page.dart';
import '../../presentation/auth/signup_page.dart';
import '../../presentation/auth/splash_page.dart';
import '../../presentation/chat/chat_list_page.dart';
import '../../presentation/chat/chat_page.dart';
import '../../presentation/parent/appointment/booking_details_page.dart';
import '../../presentation/parent/appointment/trainer_list_page.dart';
import '../../presentation/parent/parent_bottom_nav_page.dart';
import '../../presentation/parent/parent_progress_page.dart';
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
    AutoRoute(page: TrainerListRoute.page),
    AutoRoute(page: ChatRoute.page),
  ];
}
