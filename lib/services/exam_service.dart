import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String _baseUrl = 'https://chatbotia-backend.onrender.com'; // Reemplaza con tu URL

  Future<Map<String, dynamic>> sendQuery(String endpoint, String message) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
