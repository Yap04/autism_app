import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../core/config/api_keys.dart';

class ImageService {
  static Future<String?> uploadToImgBB(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final url = Uri.parse('https://api.imgbb.com/1/upload');
      final response = await http.post(
        url,
        body: {'key': ApiKeys.imgbb, 'image': base64Image},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['data'] as Map<String, dynamic>;
        return data['display_url'] as String?;
      } else {
        print('Upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
