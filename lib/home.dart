import 'package:chatbotia_movil/ChatPage.dart';
import 'package:chatbotia_movil/chat_screem.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Add this line to import the 'dart:convert' package
import 'package:flutter/services.dart'; // Importar paquete para cambiar el color de la barra de estado
import 'package:chatbotia_movil/chat_home.dart';
import 'package:chatbotia_movil/PharmacyChatPage.dart'; // Add this line to import PharmacyChatPage
import 'package:chatbotia_movil/ExamChatPage.dart'; // Add this line to import ExamChatPage
import 'package:chatbotia_movil/PersonalizedMonitoringPage.dart'; // Add this line to import PersonalizedMonitoringPage
import 'package:chatbotia_movil/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatbotia_movil/services/PrescriptionService.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(AssisMedApp());
}

class AssisMedApp extends StatelessWidget {
  const AssisMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/': (context) => HomePage(),
        '/chatbot': (context) => ChatbotPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showOverlay = false;
  bool _isVisible= false;
  Color _cardColor1 = Colors.white;
  Color _cardColor2 = Colors.white;
  Color _cardColor3 = Colors.white;
  String? userName; // Variable para almacenar el nombre del usuario
  List<Map<String, dynamic>> _messages =
      []; // Define _messages as a list of maps

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name'); // Cambiar a 'name'

    if (storedName != null) {
      print('Nombre recuperado correctamente: $storedName');
      setState(() {
        userName = storedName;
      });
    } else {
      print('No se encontró ningún nombre almacenado.');
      setState(() {
        userName =
            'Cargando...'; // Valor estático para verificar el renderizado
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = (screenSize.width / 2) - 26;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
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
            Icons.emergency_share,
            color: const Color.fromARGB(255, 90, 32, 32),
            size: 31,
          ),
          onTap: () {
            _showPanicButtonDialog(context, '2', userName ?? 'Usuario');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
                size: 31,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      initialMessage: 'Quisiera saber mis Recordatorios',
                      userId: '1', // Add the appropriate userId here
                      queryType:
                          'defaultQueryType', // Define the appropriate queryType here
                    ),
                  ),
                );
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
                    'assets/logo.png',
                    height: screenSize.height * 0.15,
                    color: null,
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
                        'Bienvenido Jose ${userName ?? 'Jose'}',
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
                          Expanded(
                              child: _buildInfoCard(
                                  '100', 'Mg/dl', 'Glucosa Normal')),
                          SizedBox(width: 10),
                          Expanded(
                              child: _buildInfoCard(
                                  '210', 'Mg/dl', 'Glucosa muy alta')),
                          SizedBox(width: 10),
                          Expanded(
                              child: _buildInfoCard(
                                  '60', 'Mg/dl', 'Glucosa muy baja')),
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPres(
                                    initialMessages: [],
                                    initialMessage: 'Consultar receta',
                                    userId:
                                        '1', // Ajusta el userId según sea necesario
                                    queryType:
                                        'consultaReceta', // Ajusta el queryType según sea necesario
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // Fondo transparente
                              shadowColor: Colors.transparent, // Sin sombra
                              padding: EdgeInsets.zero, // Sin padding
                            ),
                            child: SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 26,
                              child: _buildStyledInfoCard(
                                '1',
                                'Nuevo',
                                'Recordatorio',
                                Icons.notifications,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PharmacyChatPage(initialMessage: "farmacias"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              width: buttonWidth,
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
                                      Icon(Icons.local_pharmacy, color: Colors.purple, size: 24),
                                      Flexible(
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Sugerencias de Farmacias',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción para próxima cita médica
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              width: buttonWidth,
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
                                      Icon(Icons.calendar_today, color: Colors.purple, size: 24),
                                      Flexible(
                                        child: Text(
                                          'lunes\n07:30 am',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Proxima cita',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(initialMessage: "recetas"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              width: buttonWidth,
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
                                      Icon(Icons.monetization_on_sharp, color: Colors.purple, size: 24),
                                      Flexible(
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Consultar recetas',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamChatPage(initialMessage: "examen"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              width: buttonWidth,
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
                                      Icon(Icons.analytics, color: Colors.purple, size: 24),
                                      Flexible(
                                        child: Text(
                                          '2',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Análisis de Exámenes',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonalizedMonitoringPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              width: buttonWidth,
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
                                      Icon(Icons.dashboard, color: Colors.purple, size: 24),
                                      Flexible(
                                        child: Text(
                                          'Monitoreo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Monitoreo Personalizado',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home, size: 32),
              onPressed: () {
                // Acción para el ícono de home
              },
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.play_circle_fill, size: 32),
              onPressed: () {
                // Acción para el ícono de video
              },
            ),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.chat, size: 32),
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
                );
              },
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.settings, size: 32),
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
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
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
                      fontSize: 20,
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
      ),
    );
  }

  void _fetchPrescription() async {
    final PrescriptionService prescriptionService = PrescriptionService();

    try {
      final response = await prescriptionService.getPrescriptions('12345');

      setState(() {
        _messages.add({
          "text": _translatePrescription(response),
          "isSender": false,
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "text": 'Error al obtener las recetas: $e',
          "isSender": false,
        });
      });
    }
  }

  String _translatePrescription(Map<String, dynamic> data) {
    if (data.containsKey('prescriptions')) {
      final prescriptions = data['prescriptions']
          .map((p) =>
              '${p["medication"]}: ${p["instructions"]} (${p["dosage"]})')
          .join('\n');
      return 'Recetas encontradas:\n$prescriptions\nCosto total: \$${data["total_cost"]}';
    } else {
      return 'No se encontraron recetas para este paciente.';
    }
  }

  void _showPanicButtonDialog(
      BuildContext context, String patientId, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar alerta'),
          content: Text(
              '¿Está seguro de que desea enviar una alerta de nivel de glucosa alta?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enviar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _sendPanicButtonRequest(context, patientId, name);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendPanicButtonRequest(
      BuildContext context, String patientId, String name) async {
    final url = Uri.parse(
        'https://chatbotia-backend.onrender.com/panic_button/trigger');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'patient_id': patientId,
        'name': name,
        'reason': 'Nivel de glucosa alta',
      }),
    );

    if (response.statusCode == 200) {
      _showConfirmationDialog(context);
    } else {
      _showErrorDialog(context);
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta enviada'),
          content: Text(
              'La alerta de nivel de glucosa alta ha sido enviada exitosamente.'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Hubo un error al enviar la alerta. Por favor, inténtelo de nuevo.'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyForm(BuildContext context, String patientId) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _doctorContactController = TextEditingController();
    final _familyContactController = TextEditingController();
    final _emergencyReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configurar botón de emergencia'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _doctorContactController,
                    decoration:
                        InputDecoration(labelText: 'Contacto del doctor'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el contacto del doctor';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _familyContactController,
                    decoration: InputDecoration(labelText: 'Contacto familiar'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el contacto familiar';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emergencyReasonController,
                    decoration:
                        InputDecoration(labelText: 'Razón de emergencia'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la razón de emergencia';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _sendEmergencyData(
                    context,
                    patientId,
                    _nameController.text,
                    _doctorContactController.text,
                    _familyContactController.text,
                    _emergencyReasonController.text,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _sendEmergencyData(
    BuildContext context,
    String patientId,
    String name,
    String doctorContact,
    String familyContact,
    String emergencyReason,
  ) async {
    final url =
        Uri.parse('https://chatbotia-backend.onrender.com/panic_button/config');

    final requestBody = {
      "patient_id": patientId,
      "name": name,
      "doctor_contact": doctorContact,
      "family_contact": familyContact,
      "emergency_reasons": [emergencyReason]
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Configuración guardada con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la configuración')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                      leading: Icon(Icons.emergency_share_outlined),
                      title: Text('Confirgurar boton de emergencia'),
                      onTap: () {
                        _showEmergencyForm(context, '2');
                        // Acción para configurar el botón de emergencia
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Cerrar sesión'),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('access_token');
                        await prefs.remove('name');
                        Navigator.pushReplacementNamed(context, '/login');
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
