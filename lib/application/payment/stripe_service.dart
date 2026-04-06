import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _secretKey =
      'sk_test_51RbCKq4Tjoljxbmo4gHkZ0lePtFA0fHj6XWXyemurolOFlGFu7T4EPfUkIKLZJhzzLCoFPyChG1bcIkun8fVZ2ce00KZ7qCtcz';

  static Future<bool> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(amount, currency);
      if (paymentIntent == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'].toString(),
          merchantDisplayName: 'Autism Sports Training App',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      debugPrint('Stripe Payment Error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> _createPaymentIntent(
    double amount,
    String currency,
  ) async {
    try {
      final amountInCents = (amount * 100).toInt();

      final body = <String, dynamic>{
        'amount': amountInCents.toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (err) {
      debugPrint('Create Intent Error: $err');
      return null;
    }
  }
}
