import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiUrl = 'https://chatbotia-backend.onrender.com/chat';

  Future<Map<String, dynamic>> sendQuery(String queryType, String query) async {
    try {
      final Uri url = Uri.parse('$apiUrl?query_type=$queryType&query=$query&user_id=1');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error en la solicitud: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
