import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/api_keys.dart';
import 'core/config/firebase_options.dart';
import 'core/constant/color_constant.dart';
import 'core/routes/app_router.dart';
import 'infrastructure/services/local_notification_service.dart';

final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    Stripe.publishableKey = ApiKeys.publicKey;
    await Stripe.instance.applySettings();

    final notificationService = LocalNotificationService();
    await notificationService.init();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ThemeColor.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      builder: BotToastInit(),
      routerConfig: _appRouter.config(
        navigatorObservers: () => [BotToastNavigatorObserver()],
      ),
    );
  }
}
