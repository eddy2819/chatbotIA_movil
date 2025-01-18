import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class Chat extends StatefulWidget {
  final List<Map<String, dynamic>>? initialMessages;
  final String initialMessage;

  const Chat({super.key, this.initialMessages, this.initialMessage = ''});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessages != null) {
      _messages.addAll(widget.initialMessages!);
    }
    if (widget.initialMessage.isNotEmpty) {
      _messages.add({"text": widget.initialMessage, "isSender": true});
    }
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();
    _requestPermissions();
  }

  Future<void> _initializeRecorder() async {
    await _recorder!.openRecorder();
    await Permission.microphone.request();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"text": text, "isSender": true});
    });

    _messageController.clear();

    // Simular respuesta automática
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages
            .add({"text": "Gracias por tu mensaje: $text", "isSender": false});
      });
    });
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _messages.add({
          "text": "Archivo seleccionado",
          "isSender": true,
          "file": result.files.single.path
        });
      });
    }
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _messages.add({
          "text": "Imagen seleccionada",
          "isSender": true,
          "image": image.path
        });
      });
    }
  }

  void _showAttachmentOptions() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tomar una foto'),
                onTap: () {
                  Navigator.pop(context, 'camera');
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Seleccionar un archivo'),
                onTap: () {
                  Navigator.pop(context, 'file');
                },
              ),
            ],
          ),
        );
      },
    );
    if (action == 'camera') {
      _pickImage();
    } else if (action == 'file') {
      _pickFile();
    }
  }

  void _startRecording() async {
    if (await Permission.microphone.isGranted) {
      await _recorder!.startRecorder(toFile: 'audio');
      setState(() {
        _isRecording = true;
      });
    } else {
      _requestPermissions();
    }
  }

  void _stopRecording() async {
    final path = await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      _messages
          .add({"text": "Mensaje de voz", "isSender": true, "audio": path});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          if (widget.initialMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.initialMessage,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
                      message["text"],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.purple,
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.purple),
                  onPressed: _showAttachmentOptions,
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
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
