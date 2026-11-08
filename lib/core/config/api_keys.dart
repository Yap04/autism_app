import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get imgbb => dotenv.env['IMGBB_KEY'] ?? '';
  static String get googleMaps => dotenv.env['GOOGLE_MAPS_KEY'] ?? '';
  static String get geminiKey => dotenv.env['GEMINI_KEY'] ?? '';

  // stripe api keys
  static String get publicKey => dotenv.env['STRIPE_PUBLIC_KEY'] ?? '';
  static String get secretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';
}
