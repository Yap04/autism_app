import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            if (user.role == UserRole.trainer) {
              context.replaceRoute(const TrainerBottomNavRoute());
            } else {
              context.replaceRoute(const ParentBottomNavRoute());
            }
          } else {
            context.replaceRoute(const LoginRoute());
          }
        },
        error: (error, stackTrace) {
          context.replaceRoute(const LoginRoute());
        },
        loading: () {},
      );
    });

    return const Scaffold(
      backgroundColor: ThemeColor.cream,
      body: Center(
        child: CircularProgressIndicator(color: ThemeColor.darkBlue),
      ),
    );
  }
}
