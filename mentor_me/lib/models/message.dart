import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message, senderUID, recieverUID;
  Timestamp time = Timestamp.now();

  Message(
      {required this.message,
      required this.senderUID,
      required this.recieverUID});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderUID': senderUID,
      'recieverUID': recieverUID,
      'time': time,
    };
  }
}
