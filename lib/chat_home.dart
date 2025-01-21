import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'services/chat_service.dart';
import 'chat.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  FlutterTts _flutterTts = FlutterTts();
  String _lastSpokenWords = '';
  bool _isQueryFromMic = false; // Nuevo flag para verificar si la consulta fue por el micrófono

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  // Inicia la escucha de voz
  Future<void> _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _lastSpokenWords = result.recognizedWords;
          _messageController.text = _lastSpokenWords;
        });
      });
    } else {
      setState(() {
        _isListening = false;
      });
    }
  }

  // Detiene la escucha de voz
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Función para leer el texto en voz alta
  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  // Envía la consulta al servicio y lee la respuesta en voz alta solo si fue activado por el micrófono
  Future<void> _sendQuery(String queryType, String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El mensaje no puede estar vacío')),
      );
      return;
    }

    try {
      final response = await _chatService.sendQuery(queryType, query);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            initialMessages: [
              {"text": query, "isSender": true},
              {
                "text": response['response'] ?? 'Sin respuesta',
                "isSender": false
              },
            ],
            userId: '1',
            queryType: queryType,
          ),
        ),
      );

      // Solo leer la respuesta si la consulta fue activada por el micrófono
      if (_isQueryFromMic) {
        _speak(response['response'] ?? 'Sin respuesta');
        setState(() {
          _isQueryFromMic = false; // Resetear el flag después de leer la respuesta
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al conectar con el servidor. Detalles: $e')),
      );
    }
  }

  // Función para manejar el envío de mensaje manual
  void _sendManualQuery(String queryType, String query) {
    _sendQuery(queryType, query);
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
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
                  icon: Icon(Icons.mic, color: _isListening ? Colors.red : Colors.purple),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    _isQueryFromMic = true; // Marcar que la consulta proviene del micrófono
                    _sendQuery('inicio', message);
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
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
                    _sendManualQuery('diabetes', '¿Qué es la diabetes?');
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
                    _sendManualQuery('inicio', 'hola');
                  },
                  child: Text(
                    'Iniciar chat',
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
