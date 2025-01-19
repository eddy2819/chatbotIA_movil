import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String apiUrl = 'https://chatbotia-backend.onrender.com';

  Future<Map<String, dynamic>> sendQuery(String queryType, String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception(
          'No se encontró el token de acceso. Por favor, inicie sesión nuevamente.');
    }

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'query_type': queryType,
          'query': query,
          'user_id': '123', // Usar el user_id predefinido
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        prefs.remove('access_token'); // Elimina el token almacenado
        throw Exception(
            'Token inválido o expirado. Por favor, inicie sesión nuevamente.');
      } else {
        throw Exception('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud al backend: $e');
      throw Exception('No se pudo conectar con el servidor. Detalles: $e');
    }
  }
}
