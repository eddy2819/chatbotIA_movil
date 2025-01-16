import 'package:chatbotia_movil/home.dart';
import 'package:flutter/material.dart';
import 'package:chatbotia_movil/chat.dart';// Importar la página de chat

class ChatbotPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Añadir fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.warning,
            color: const Color.fromARGB(255, 90, 32, 32),
            size: 31, // Increased icon size
          ),
          onPressed: () {
            // Acción para el ícono de warning
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
              size: 31, // Increased icon size
            ),
            onPressed: () {
              // Acción para el ícono de notificaciones
            },
          ),
        ],
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
                  icon: Icon(Icons.mic, color: Colors.purple),
                  onPressed: () {
                    // Acción para grabar voz
                  },
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.purple),
                  onPressed: () {
                    // Acción para adjuntar archivo
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
                  onPressed: () {
                    // Acción para enviar mensaje
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
                      MaterialPageRoute(builder: (context) => ChatScreen()), // Redirigir a la página de chat
                    );
                  },
                  child: Text('Iniciar Conversación',
                      style:
                          TextStyle(color: const Color.fromARGB(186, 0, 0, 0))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    // Acción para sugerencia: ¿Qué es la diabetes?
                  },
                  child: Text(
                    '¿Qué es la diabetes?',
                    style: TextStyle(color: const Color.fromARGB(186, 0, 0, 0)),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                        // Acción para cambiar contraseña
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Cambiar Email'),
                      onTap: () {
                        // Acción para cambiar email
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
}
