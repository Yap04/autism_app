import 'package:auto_route/auto_route.dart';

import '../../presentation/auth/login_page.dart';
import '../../presentation/auth/signup_page.dart';
import '../../presentation/auth/splash_page.dart';
import '../../presentation/parent/parent_bottom_nav_page.dart';
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
  ];
}
