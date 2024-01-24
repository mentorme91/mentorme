import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import 'database_service.dart';


// [ChatService] updates and manipulates the chatboxes
class ChatService extends ChangeNotifier {

  // send a message from a sender to a reciever
  Future<void> sendMessage(Message message) async {
    List ids = [message.senderUID, message.recieverUID]..sort();
    String room = ids.join('_'); // get unique chatroom ID formed by joining the sender and receiver UIDs in order

    // add message to chatroom
    await DatabaseService(uid: '')
        .chatCollection
        .doc(room)
        .collection('messages')
        .add(message.toMap());
  }

  // get message stream
  Stream<QuerySnapshot> recieveMessage(String senderUID, String recieverUID) {
    List ids = [senderUID, recieverUID]..sort();
    String room = ids.join('_'); // get unique chatroom ID

    // retrieve messages
    return DatabaseService(uid: '')
        .chatCollection
        .doc(room)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  // gets the last message in a chatroom
  Stream<QuerySnapshot> getLastMessageOf(String senderUID, String recieverUID) {
    List ids = [senderUID, recieverUID]..sort();
    String room = ids.join('_'); // get chatroom ID

    // retrieve last message
    return DatabaseService(uid: '')
        .chatCollection
        .doc(room)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }
}
