import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar paquete para cambiar el color de la barra de estado
import 'package:chatbotia_movil/chat_home.dart';

void main() {
  runApp(AssisMedApp());
}

class AssisMedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/': (context) => HomePage(), // Definir la ruta para HomePage
        '/chatbot': (context) =>
            ChatbotPage(), // Definir la ruta para ChatbotPage
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;

    // Cambiar el color de la barra de estado y la barra de navegación
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Color de la barra de estado
      statusBarIconBrightness:
          Brightness.dark, // Color de los íconos de la barra de estado
      systemNavigationBarColor: Colors.white, // Color de la barra de navegación
      systemNavigationBarIconBrightness:
          Brightness.dark, // Color de los íconos de la barra de navegación
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Asegurar que el fondo del AppBar sea blanco
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
            size: 31,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
                size: 31, // Increased icon size
              ),
              onPressed: () {
                // Acción para el ícono de notificaciones
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.png', // Add your logo asset here
                    height: screenSize.height * 0.15, // Responsive logo size
                    color:
                        null, // Removes background if the logo is a transparent PNG
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.pink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Bienvenido Jhon',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: _buildInfoCard('110', 'Mg/dl', 'Glucosa Normal')),
                          SizedBox(width: 10),
                          Expanded(child: _buildInfoCard('200', 'Mg/dl', 'Glucosa muy alta')),
                          SizedBox(width: 10),
                          Expanded(child: _buildInfoCard('70', 'Mg/dl', 'Glucosa muy baja')),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 26,
                            child: _buildStyledInfoCard('110', 'Mg/dl',
                                'Nivel de glucosa', Icons.bloodtype),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 26,
                            child: _buildStyledInfoCard('3', 'Farmacias cercanas',
                                'Sugerencias de Farmacias', Icons.local_pharmacy),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 26,
                            child: _buildStyledInfoCard('28/11/2024\n07:30 am', '',
                                'Proxima cita Médica', Icons.calendar_today),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 26,
                            child: _buildStyledInfoCard('1', 'Recordatorios',
                                'Recordatorios', Icons.notifications),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                    width: screenSize.width * 0.8, // Responsive overlay width
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home, size: 32), // Increased icon size
              onPressed: () {
                // Acción para el ícono de home
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
              icon: Icon(Icons.chat, size: 32), // Increased icon size
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ChatbotPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
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
                ); // Navegar a ChatbotPage con animación
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }

  Widget _buildInfoCard(String value, String unit, String description) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (unit.isNotEmpty)
            Text(
              unit,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledInfoCard(
      String value, String unit, String description, IconData icon) {
    return Container(
      width: 180, // Made the card slightly wider
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.purple, size: 24),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20, // Adjusted font size for better fit
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          if (unit.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
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
