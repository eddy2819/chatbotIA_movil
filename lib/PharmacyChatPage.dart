import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Paquete para obtener la ubicación

class PharmacyChatPage extends StatefulWidget {
  final String initialMessage;

  const PharmacyChatPage({Key? key, required this.initialMessage}) : super(key: key);

  @override
  _PharmacyChatPageState createState() => _PharmacyChatPageState();
}

class _PharmacyChatPageState extends State<PharmacyChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  late GoogleMapController mapController;
  LatLng _currentLocation = const LatLng(-3.997175, -79.200098); // Ubicación inicial
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage.isNotEmpty) {
      _handleUserMessage(widget.initialMessage);
    }
    _getCurrentLocation(); // Obtener la ubicación actual al inicio
  }

  // Función para obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude); // Actualizar las coordenadas
    });

    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation)); // Mover el mapa a la nueva ubicación
  }

  Future<void> _handleUserMessage(String message) async {
    setState(() {
      messages.add({"sender": "user", "text": message});
    });

    if (message.toLowerCase() == "farmacias") {
      await _fetchNearbyPharmacies();
    } else {
      _addSystemResponse("Lo siento, no entendí eso. Intenta escribir 'farmacias'.");
    }
  }

  Future<void> _fetchNearbyPharmacies() async {
    final url = Uri.parse("https://chatbotia-backend.onrender.com/pharmacies/nearby");
    final body = json.encode({
      "location": {
        "latitude": _currentLocation.latitude,
        "longitude": _currentLocation.longitude
      },
      "query": "farmacias"
    });

    try {
      final response = await http.post(url, headers: {
        "accept": "application/json",
        "Content-Type": "application/json"
      }, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pharmacies = data['pharmacies']; // Acceder a las farmacias

        String pharmacyNames = '';
        for (var pharmacy in pharmacies) {
          pharmacyNames += pharmacy['name'] + "\n"; // Obtener los nombres de las farmacias
        }

        // Agregar la respuesta con los nombres de las farmacias
        _addSystemResponse("Las farmacias cercanas son:\n$pharmacyNames");
        setState(() {});
      } else {
        _addSystemResponse("Hubo un error al obtener las farmacias. Inténtalo más tarde.");
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
        title: Text("Chat de Farmacias"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14.0,
              ),
              markers: Set<Marker>.of(_markers),
            ),
          ),
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
