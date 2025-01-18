import 'package:chatbotia_movil/home.dart';
import 'package:flutter/material.dart';
import 'package:chatbotia_movil/chat.dart'; // Importar la página de chat
import 'package:image_picker/image_picker.dart'; // Importar paquete para seleccionar imágenes
import 'package:file_picker/file_picker.dart'; // Importar paquete para seleccionar archivos
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final TextEditingController _messageController = TextEditingController();
  bool _isRecording = false;
  bool _showOverlay = false; // Añadir variable para el overlay

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _requestPermissions();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
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

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            initialMessages: [
              {
                "text": "Imagen seleccionada",
                "isSender": true,
                "image": image.path
              }
            ],
          ),
        ),
      );
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            initialMessages: [
              {
                "text": "Archivo seleccionado",
                "isSender": true,
                "file": result.files.single.path
              }
            ],
          ),
        ),
      );
    }
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      await _recorder.startRecorder(toFile: 'audio');
      setState(() {
        _isRecording = true;
      });
    } else {
      _requestPermissions();
    }
  }

  Future<void> _stopRecording(BuildContext context) async {
    final path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          initialMessages: [
            {"text": "Mensaje de voz", "isSender": true, "audio": path}
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Añadir fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onLongPress: () {
            setState(() {
              _showOverlay = true;
            });
          },
          child: Icon(
            Icons.warning,
            color: const Color.fromARGB(255, 90, 32, 32),
            size: 31, // Increased icon size
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
              size: 31, // Increased icon size
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(
                    initialMessage: 'Quisiera saber mis Recordatorios',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo y título
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png', // Ruta del logo, asegúrate de incluirlo en tu proyecto
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
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.purple,
                      ),
                      onPressed: _isRecording
                          ? () => _stopRecording(context)
                          : _startRecording,
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.purple),
                      onPressed: () async {
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
                          _pickImage(context);
                        } else if (action == 'file') {
                          _pickFile(context);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.purple),
                      onPressed: () {
                        final message = _messageController.text;
                        if (message.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                initialMessage: message,
                              ),
                            ),
                          );
                        }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Chat()), // Redirigir a la página de chat
                        );
                      },
                      child: Text('Iniciar Conversación',
                          style: TextStyle(
                              color: const Color.fromARGB(186, 0, 0, 0))),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                    initialMessage: '¿Qué es la diabetes?',
                                  )), // Redirigir a la página de chat con mensaje predeterminado
                        );
                      },
                      child: Text(
                        '¿Qué es la diabetes?',
                        style: TextStyle(
                            color: const Color.fromARGB(186, 0, 0, 0)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showOverlay)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOverlay = false;
                });
              },
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Responsive overlay width
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 48),
                        SizedBox(height: 10),
                        Text(
                          'Estimado usuario, su mensaje de alerta fue enviado',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showOverlay = false;
                            });
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Índice para resaltar esta página
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home, size: 32), // Increased icon size
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        HomePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                ); // Navegar a HomePage con animación
              },
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon:
                  Icon(Icons.play_circle_fill, size: 32), // Increased icon size
              onPressed: () {
                // Acción para el ícono de play_circle_fill
              },
            ),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.chat,
                  size: 32,
                  color:
                      Color.fromRGBO(156, 39, 176, 1)), // Increased icon size
              onPressed: () {
                // Acción para el ícono de chat
              },
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.settings, size: 32), // Increased icon size
              onPressed: () {
                _showSettingsModal(context); // Mostrar modal de configuración
              },
            ),
            label: 'Configuración',
          ),
        ],
        selectedItemColor: const Color.fromRGBO(158, 158, 158, 1),
        unselectedItemColor: const Color.fromRGBO(158, 158, 158, 1),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }

  // Función para mostrar el modal de configuración
  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite ajustar la altura según el contenido
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Configuraciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Cambiar contraseña'),
                      onTap: () {
                        _showChangePasswordDialog(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Cambiar Email'),
                      onTap: () {
                        _showChangeEmailDialog(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notificaciones'),
                      onTap: () {
                        // Acción para notificaciones
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.palette),
                      title: Text('Personalizar diseño'),
                      onTap: () {
                        // Acción para personalizar diseño
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Función para mostrar el diálogo de cambiar contraseña
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _oldPasswordController =
            TextEditingController();
        final TextEditingController _newPasswordController =
            TextEditingController();
        return AlertDialog(
          title: Text('Cambiar contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(hintText: 'Contraseña anterior'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(hintText: 'Nueva contraseña'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para cambiar la contraseña
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el diálogo de cambiar email
  void _showChangeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _emailController = TextEditingController();
        return AlertDialog(
          title: Text('Cambiar Email'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(hintText: 'Nuevo Email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para cambiar el email
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
