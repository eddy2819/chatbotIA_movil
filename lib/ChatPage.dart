import 'package:flutter/material.dart';
import 'dart:convert'; // Para manejar JSON
import 'package:http/http.dart' as http; // Para manejar las peticiones HTTP

class ChatPage extends StatefulWidget {
  final String initialMessage;

  const ChatPage({Key? key, required this.initialMessage}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage.isNotEmpty) {
      _handleUserMessage(widget.initialMessage);
    }
  }

  Future<void> _handleUserMessage(String message) async {
    setState(() {
      messages.add({"sender": "user", "text": message});
    });

    if (message.toLowerCase() == "recetas") {
      await _fetchPrescriptions();
    } else {
      _addSystemResponse("Lo siento, no entendí eso. Intenta escribir 'recetas'.");
    }
  }

  Future<void> _fetchPrescriptions() async {
    final url = Uri.parse(
        "https://chatbotia-backend.onrender.com/prescriptions?patient_id=12345");
    try {
      final response = await http.get(url, headers: {"accept": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prescriptions = data['prescriptions'] as List;

        String responseText = "Aquí tienes tus recetas:\n";
        for (var prescription in prescriptions) {
          responseText +=
              "- ${prescription['medication']}: ${prescription['dosage']}\n  ${prescription['instructions']}\n";
        }

        responseText += "\nCosto total: \$${data['total_cost']}";

        _addSystemResponse(responseText);
      } else {
        _addSystemResponse("Hubo un error al obtener las recetas. Inténtalo más tarde.");
      }
    } catch (e) {
      _addSystemResponse("Error de conexión. Revisa tu red e inténtalo de nuevo.");
    }
  }

  void _addSystemResponse(String text) {
    setState(() {
      messages.add({"sender": "system", "text": _removeSpecialCharacters(text)});
    });
  }

  String _removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s,.]'), '');
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      _handleUserMessage(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
