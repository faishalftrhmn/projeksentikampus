import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sentiment_result.dart';

class SentimentApi {
  // Gunakan 'http://10.0.2.2:8000' jika menggunakan Android Emulator
  // Gunakan 'http://127.0.0.1:8000' jika menguji di Chrome / Desktop Windows
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<SentimentResult> predict(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server: ${response.statusCode}');
    }

    return SentimentResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}