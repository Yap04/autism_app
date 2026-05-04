import 'dart:convert';

import 'package:http/http.dart' as http;

class RemoteNotificationService {
  static Future<void> notifyOtherUser({
    required String targetFcmToken,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse('https://fyp-api-sandy.vercel.app/api/notify');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': targetFcmToken,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        print('Remote notification request sent to Vercel');
      } else {
        print('Notification failed, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Vercel request error: $e');
    }
  }
}
