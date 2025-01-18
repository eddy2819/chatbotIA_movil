class Message {
  final String message;
  final bool isSender;
  final DateTime timestamp;

  Message({
    required this.message,
    required this.isSender,
    required this.timestamp,
  });

  // Crear un objeto Message desde un JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      isSender: json['isSender'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Convertir un objeto Message a JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isSender': isSender,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
