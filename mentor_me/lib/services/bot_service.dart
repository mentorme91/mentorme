import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentor_me/models/bot_message.dart';
import 'package:mentor_me/services/database_service.dart';

import 'package:http/http.dart' as http;

Future<String> getData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

class BotService {
  String courseCode, uid;

  BotService({required this.courseCode, required this.uid});

  Stream<QuerySnapshot> getMessages() {
    String course = courseCode.split(' ').join('');
    String bot_id = [uid, course].join('_');
    return DatabaseService(uid: '')
        .botMessageCollection
        .doc(bot_id)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future addMessage(BotMessage message) async {
    String course = courseCode.split(' ').join('');
    String bot_id = [uid, course].join('_');

    await DatabaseService(uid: '')
        .botMessageCollection
        .doc(bot_id)
        .collection('messages')
        .add(message.toMap());
  }
}
