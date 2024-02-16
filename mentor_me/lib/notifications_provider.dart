import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'models/notification.dart';
import 'models/user.dart';
import 'services/chat_service.dart';
import 'services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final ChatService _chatService = ChatService();
  late StreamSubscription _streamSubscription;
  late MyUser user;
  var _previousData;

  NotificationProvider({required this.user}) {
    _subscribeToMessages(_chatService.recieveMessage(user.uid ?? '', 'zOQXv216wfdtaDv63EHcDA9kZWg1'));
  }

  void _subscribeToMessages(Stream<QuerySnapshot<Object?>> receiveMessages) {
    _streamSubscription = receiveMessages.listen((data) {
      if (data != _previousData) {
        _previousData = data; // Update previous data
        MyNotification notification =
            MyNotification(title: 'New Message', body: 'Hello world!');
        _notificationService.showNotification(notification);
        print('Hello!');
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
