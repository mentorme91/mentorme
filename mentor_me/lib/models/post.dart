import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? userPhotoURL, content, title, userName;
  int likes = 0;
  List comments = [];
  Timestamp time = Timestamp.now();

  Post({
    this.content,
    this.title,
    this.userName,
    this.userPhotoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'photoURL': userPhotoURL,
      'name': userName,
      'title': title,
      'content': content,
      'time': time,
      'likes': likes,
      'comments': comments,
    };
  }

  void updateFromMap(Map<String, dynamic> map) {
    userPhotoURL = map['photoURL'];
    userName = map['name'];
    title = map['title'];
    content = map['content'];
    time = map['time'];
    likes = map['likes'];
    comments = map['comments'];
  }
}
