class ChatService {
  Future<List<Map<String, dynamic>>> fetchMessages() async {
    // Simular un retraso de red
    await Future.delayed(Duration(seconds: 1));
    return [
      {"text": "Hola, ¿en qué puedo ayudarte?", "isSender": false},
      {"text": "Quiero cargar un archivo.", "isSender": true},
    ];
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    // Simular un retraso de red
    await Future.delayed(Duration(seconds: 1));
    return {"text": "Gracias por tu mensaje: $message", "isSender": false};
  }
}
