import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import 'database_service.dart';

class ChatService extends ChangeNotifier {
  Future<void> sendMessage(Message message) async {
    List ids = [message.senderUID, message.recieverUID]..sort();
    String room = ids.join('_');
    await DatabaseService(uid: '')
        .chatCollection
        .doc(room)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<QuerySnapshot> recieveMessage(String senderUID, String recieverUID) {
    List ids = [senderUID, recieverUID]..sort();
    String room = ids.join('_');
    return DatabaseService(uid: '')
        .chatCollection
        .doc(room)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessageOf(String senderUID, String recieverUID) {
    List ids = [senderUID, recieverUID]..sort();
    String room = ids.join('_');
    return DatabaseService(uid: '')
        .chatCollection
        .doc(room)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }
}
