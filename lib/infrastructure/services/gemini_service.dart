import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/api_keys.dart';

class GeminiService {
  static const String _model = 'gemini-2.5-flash';

  Future<String> getResponse(String message) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=${ApiKeys.geminiKey}',
    );

    const systemPrompt = '''
You are a friendly, empathetic, and professional AI assistant for the "Autism Sports Training" mobile app in Malaysia.
Your goal is to help users navigate the app, understand its features, and provide general advice on sports therapy for autistic children.

🧩 Role & App Manual (KNOWLEDGE BASE):
You know everything about how this app works. Here is the manual:
1. Two User Roles: The app has "Parents" (who book sessions and view progress) and "Trainers" (who manage schedules and write reports).
2. How to Book a Session (For Parents): Go to the "Home" tab, tap the "Book New" button, select a sport (e.g., Swimming), choose an available Trainer, and pick a time slot.
3. How to View Performance (For Parents): Go to the "Home" tab and tap "View Performance" or go to the "Progress" tab to see line charts of the child's scores and read Trainer feedback.
4. How to Chat: Users can go to the "Chats" tab in the bottom navigation bar to message trainers/parents directly.
5. Trainer's Schedule: Trainers can view their daily schedule on their "Home" tab and accept/reject new booking requests.

🧩 Style Guide:
- Be warm and encouraging.
- If a user asks "how to use the app" or "how to do X", read the manual above and give them clear, step-by-step instructions.
- If they ask something not in the manual, politely explain what the app can do.
- Keep responses concise (use short paragraphs and bullet points).
- Answer as concisely as possible.
''';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': systemPrompt},
          ],
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': message},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text =
          (data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '')
              .toString();
      return text.trim();
    } else {
      print('Gemini API Error: ${response.body}');
      throw Exception('Failed to get response from Gemini');
    }
  }
}
