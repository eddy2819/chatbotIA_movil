import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ExamChatPage extends StatefulWidget {
  final String initialMessage;

  const ExamChatPage({Key? key, required this.initialMessage})
      : super(key: key);

  @override
  _ExamChatPageState createState() => _ExamChatPageState();
}

class _ExamChatPageState extends State<ExamChatPage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final String _examId = "DTvH2izH8gDmGQucCqkJ"; // exam_id fijo

  @override
  void initState() {
    super.initState();
    // Mostrar el mensaje inicial
    _messages.add({"text": widget.initialMessage, "isSender": false});
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({"text": message, "isSender": true});
    });

    final response = await http.post(
      Uri.parse('https://chatbotia-backend.onrender.com/initiate_exam_upload/'),
      body: json.encode(message),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _messages.add({"text": responseData['message'], "isSender": false});
      });
    } else {
      setState(() {
        _messages.add({
          "text":
              'Error al conectar con el servidor. Detalles: ${response.body}',
          "isSender": false,
        });
      });
    }
  }

  Future<void> _uploadExam() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://chatbotia-backend.onrender.com/upload_exam/'),
      );
      request.fields['exam_id'] = _examId;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData =
            json.decode(await response.stream.bytesToString());
        setState(() {
          _messages.add({
            "text": responseData['message'],
            "isSender": false,
          });
        });
      } else {
        setState(() {
          _messages.add({
            "text": "Error al cargar el examen.",
            "isSender": false,
          });
        });
      }
    }
  }

  Future<void> _analyzeExam() async {
    final response = await http.post(
      Uri.parse('https://chatbotia-backend.onrender.com/analyze_exam/'),
      body: json.encode({
        "exam_id": _examId,
        "response": "si",
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _messages.add({"text": responseData['message'], "isSender": false});
        _messages.add({
          "text": responseData['analysis']['summary'],
          "isSender": false,
        });
        for (String detail in responseData['analysis']['analysis']['details']) {
          _messages.add({"text": detail, "isSender": false});
        }
      });
    } else {
      setState(() {
        _messages.add({
          "text": "Error al analizar el examen. Detalles: ${response.body}",
          "isSender": false,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat de Análisis de Exámenes',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                    alignment: message["isSender"]
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message["isSender"]
                            ? Colors.purple.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message["text"].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(0, -2))
            ]),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.purple),
                  onPressed: _uploadExam,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Escribe tu mensaje'),
                    onSubmitted: (text) {
                      _sendMessage(text);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.analytics, color: Colors.purple),
                  onPressed: _analyzeExam,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
