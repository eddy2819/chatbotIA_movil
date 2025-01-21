import 'dart:convert';
import 'package:http/http.dart' as http;

class PrescriptionService {
  final String _baseUrl = 'https://chatbotia-backend.onrender.com';

  Future<Map<String, dynamic>> getPrescriptions(String patientId) async {
    final url = Uri.parse('$_baseUrl/prescriptions?patient_id=$patientId');

    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener las recetas médicas. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}
