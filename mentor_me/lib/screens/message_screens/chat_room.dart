import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentor_me/services/services.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoom;
  const ChatRoom({required this.chatRoom, super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: '').chatRoom(widget.chatRoom),
        initialData: null,
        builder: (context, snapshot) {
          return Scaffold(
            body: Text('Hello!'),
          );
        });
  }
}
