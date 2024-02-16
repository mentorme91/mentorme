import 'package:cloud_firestore/cloud_firestore.dart';

class BotMessage {
  String message;
  bool isBot;
  Timestamp time = Timestamp.now();

  BotMessage({
    required this.message,
    required this.isBot,
  });

  // convert message object to map to add in firebase chatroom
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'isBot': isBot,
      'time': time,
    };
  }
}
