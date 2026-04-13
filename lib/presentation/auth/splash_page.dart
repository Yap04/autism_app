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
      next.whenData((user) {
        if (user == null) {
          context.router.replaceAll([const LoginRoute()]);
        } else if (user.name?.isEmpty ?? true) {
          context.router.replaceAll([const EditProfileRoute()]);
        } else {
          if (user.role == UserRole.parent) {
            context.router.replaceAll([const ParentBottomNavRoute()]);
          } else {
            context.router.replaceAll([const TrainerBottomNavRoute()]);
          }
        }
      });
    });

    return const Scaffold(
      backgroundColor: ThemeColor.cream,
      body: Center(
        child: CircularProgressIndicator(color: ThemeColor.darkBlue),
      ),
    );
  }
}
