import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import '../models/event.dart';
import '../models/event.dart';
import '../models/post.dart';
import '../models/request.dart';
import '../models/user.dart';

// Database service: controls manipulation of the database
class DatabaseService extends ChangeNotifier {
  // string user id
  final String? uid;

  // constructor for database service
  DatabaseService({
    required this.uid,
  });

  // get the collection of all students in the database
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('all_students');
  // get the collection of all schools in the database
  // final CollectionReference schoolsCollection =
  //     FirebaseFirestore.instance.collection('schools');
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('all_posts');
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat_rooms');
  final CollectionReference documentCollection =
      FirebaseFirestore.instance.collection('resource_documents');

  // update all student collections and student collections in respective schools
  Future UpdateStudentCollection(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.todict() ?? {};
    Map<String, Request> requests = dic['requests'];
    Map newRequests =
        requests.map((key, value) => MapEntry(key, value.toMap()));
    dic['requests'] = newRequests;
    // update all student collections and student collections in respective schools
    await studentsCollection.doc(user?.uid).set(dic);
    // await schoolsCollection
    //     .doc(user?.school_id)
    //     .collection('faculties')
    //     .doc(user?.faculty)
    //     .collection('departments')
    //     .doc(user?.department)
    //     .collection('students')
    //     .doc(user?.uid)
    //     .set(dic);
    notifyListeners();
  }

  void postNewPost(Post post, String postName) {
    postsCollection.doc(postName).collection('posts').add(post.toMap());
    notifyListeners();
  }

  // get user data snapshots
  Stream<DocumentSnapshot> get userData {
    return studentsCollection.doc(uid).snapshots();
  }

  Future<MyUser> get userInfo async {
    DocumentSnapshot<Object?> val = await studentsCollection.doc(uid).get();
    Map data = val.data() as Map<String, dynamic>;
    MyUser user = MyUser()..updateFromMap(data);
    return user;
  }

  Stream<DocumentSnapshot> get posts {
    return postsCollection.doc('posts').snapshots();
  }

  Future<List<Post>> allPosts(String postName) async {
    List<Post> allPosts = [];
    QuerySnapshot<Object?> posts = await postsCollection
        .doc(postName)
        .collection('posts')
        .orderBy('time', descending: false)
        .get();
    for (var post in posts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      Post thisPost = Post()..updateFromMap(postData);
      allPosts.add(thisPost);
    }
    return allPosts;
  }

  Stream<DocumentSnapshot> chatRoom(String roomID) {
    return postsCollection.doc(roomID).snapshots();
  }

  Stream<QuerySnapshot> getDocuments(String school, String courseCode) {
    return documentCollection.doc(school).collection(courseCode).snapshots();
  }

  Stream<QuerySnapshot> userMatches() {
    return studentsCollection.snapshots();
  }

  Future<Map<MyUser, int>> matches(MyUser? user) async {
    Map<MyUser, int> matches = {};

    QuerySnapshot studentQuery = await studentsCollection.get();
    for (var student in studentQuery.docs) {
      Map<String, dynamic> studentData = student.data() as Map<String, dynamic>;
      if ((studentData['school_id'] == user?.school_id) &&
          (studentData['uid'] != user?.uid) &&
          !(user?.connections.contains(studentData['uid']) ?? false)) {
        int percent = 20;
        percent += (studentData['faculty'] == user?.faculty) ? 55 : 0;
        percent += (studentData['department'] == user?.department) ? 20 : 0;
        MyUser match = MyUser()..updateFromMap(studentData);
        matches[match] = percent;
      }
    }
    return matches;
  }

  Future<void> setTasks(Map<String, dynamic> map) async {
    await studentsCollection
        .doc(uid)
        .collection('schedule_tasks')
        .doc('document')
        .set(map);
  }

  Future<List<dynamic>> getTasks() async {
    DocumentSnapshot<Map<String, dynamic>> document = await studentsCollection
        .doc(uid)
        .collection('schedule_tasks')
        .doc('document')
        .get();
    Map<String, dynamic> documentData = document.data() ?? {};
    try {
      List<dynamic> tasks = documentData['tasks'];
      return tasks;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //add event
  Future<void> addEvent(Map<String, dynamic> map) async {
    await studentsCollection
        .doc(uid)
        .collection('calendar_events')
        .doc('document')
        .set(map);

    notifyListeners();
  }
  // recieve events

  Future<Map<String, List<Event>>> getEvents() async {
    DocumentSnapshot<Map<String, dynamic>> document = await studentsCollection
        .doc(uid)
        .collection('calendar_events')
        .doc('document')
        .get();
    Map<String, dynamic> documentData = document.data() ?? {};
    try {
      Map<String, List<Event>> events = documentData.map(
        (key, value) => MapEntry(
          key,
          toEvents(value as List),
        ),
      );
      return events;
    } catch (e) {
      return {};
    }
  }
}

List<Event> toEvents(List l) {
  return l
      .map(
        (event) => Event(information: '', title: '')
          ..updateFromMap(event as Map<String, dynamic>),
      )
      .toList();
}
