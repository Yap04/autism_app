import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../core/config/api_keys.dart';

class StripeService {
  Future<String?> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(amount, currency);
      if (paymentIntent == null) {
        return null;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'].toString(),
          merchantDisplayName: 'Autism Sports Training App',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return paymentIntent['id'].toString();
    } catch (e) {
      debugPrint('Stripe Payment Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
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
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
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

  Future<bool> refundStripePayment(String paymentIntentId) async {
    try {
      debugPrint('Initiating Stripe refund for: $paymentIntentId');

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/refunds'),
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'payment_intent': paymentIntentId},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint('Stripe Refund Successful: ${responseData['id']}');
        return true;
      } else {
        debugPrint('Stripe Refund Failed: ${responseData['error']['message']}');
        return false;
      }
    } catch (err) {
      debugPrint('Refund Error: $err');
      return false;
    }
  }
}
