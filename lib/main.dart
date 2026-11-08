import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';

import 'application/locale/locale_provider.dart';
import 'core/config/api_keys.dart';
import 'core/config/firebase_options.dart';
import 'core/constant/color_constant.dart';
import 'core/routes/app_router.dart';
import 'infrastructure/services/local_notification_service.dart';
import 'l10n/app_localizations.dart';

final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    Stripe.publishableKey = ApiKeys.publicKey;
    await Stripe.instance.applySettings();

    final notificationService = LocalNotificationService();
    await notificationService.init();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ThemeColor.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      locale: currentLocale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: BotToastInit(),
      routerConfig: _appRouter.config(
        navigatorObservers: () => [BotToastNavigatorObserver()],
      ),
    );
  }
}
