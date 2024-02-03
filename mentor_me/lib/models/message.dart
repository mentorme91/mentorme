import 'package:cloud_firestore/cloud_firestore.dart';

// custom message class for chat messages
class Message {
  String message, senderUID, recieverUID, status;
  Timestamp time = Timestamp.now();

  Message(
      {required this.message,
      required this.senderUID,
      required this.status,
      required this.recieverUID});

  // convert message object to map to add in firebase chatroom
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderUID': senderUID,
      'recieverUID': recieverUID,
      'time': time,
      'status': status,
    };
  }
}
