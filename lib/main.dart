import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/api_keys.dart';
import 'core/constant/color_constant.dart';
import 'core/routes/app_router.dart';
import 'firebase_options.dart';

final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Stripe.publishableKey = ApiKeys.publicKey;
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
      routerConfig: _appRouter.config(),
    );
  }
}
