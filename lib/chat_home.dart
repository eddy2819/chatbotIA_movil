import 'package:flutter/material.dart';
import 'services/chat_service.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendQuery(String queryType, String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El mensaje no puede estar vacío')),
      );
      return;
    }

    try {
      final chatService = ChatService();
      final response = await chatService.sendQuery(queryType, query);

      // Muestra la respuesta en un AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Respuesta del chatbot'),
          content: Text(response['response'] ?? 'Sin respuesta'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (e.toString().contains('Token inválido')) {
        // Si el token expiró, redirige al inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, inicie sesión nuevamente.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al conectar con el servidor. Detalles: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chatbot',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo y título
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Ruta del logo
                  height: 115,
                ),
                SizedBox(height: 16),
                Text(
                  '¿Con qué puedo ayudarte?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Entrada de mensaje
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    _sendQuery('inicio', message); // Enviar mensaje al backend
                  },
                ),
              ],
            ),
            SizedBox(height: 24),

            // Sugerencias
            Text(
              'Sugerencias sobre qué preguntarle a nuestra IA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    _sendQuery('pregunta', '¿Qué es la diabetes?');
                  },
                  child: Text(
                    '¿Qué es la diabetes?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    _sendQuery(
                        'pregunta', '¿Cuáles son los síntomas del COVID-19?');
                  },
                  child: Text(
                    'Síntomas del COVID-19',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
