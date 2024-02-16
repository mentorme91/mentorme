import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import '../models/event.dart';
import '../models/event.dart';
import '../models/link.dart';
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

  final CollectionReference botMessageCollection =
      FirebaseFirestore.instance.collection('all_bot_messages');


  // get the collection of all posts in the database
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('all_posts');


  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat_rooms');


  final CollectionReference documentCollection =
      FirebaseFirestore.instance.collection('resource_documents');


  final CollectionReference linkCollection =
      FirebaseFirestore.instance.collection('links');

  // update all student collections and student collections in respective schools
  Future UpdateStudentCollection(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    Map<String, Request> requests = dic['requests'];
    Map newRequests =
        requests.map((key, value) => MapEntry(key, value.toMap()));
    dic['requests'] = newRequests;
    // update all student collections and student collections in respective schools
    await studentsCollection.doc(user?.uid).set(dic);
    notifyListeners();
  }

  // adds a post to the database
  void postNewPost(Post post, String postName) {
    postsCollection.doc(postName).collection('posts').add(post.toMap());
    notifyListeners();
  }

  // get user data snapshots
  Stream<DocumentSnapshot> get userData {
    return studentsCollection.doc(uid).snapshots();
  }

  // get user information and converts it into a [MyUser]
  Future<MyUser> get userInfo async {
    // get the information as a Map
    DocumentSnapshot<Object?> val = await studentsCollection.doc(uid).get();
    Map data = val.data() as Map<String, dynamic>;

    // convert map to [MyUser]
    MyUser user = MyUser()..updateFromMap(data);
    return user;
  }

  // get posts
  Stream<DocumentSnapshot> get posts {
    return postsCollection.doc('posts').snapshots();
  }

  // get all posts of a certain type
  // convert the postData to [Post] class
  // return list of all posts
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

  // get chatroom information stream
  Stream<DocumentSnapshot> chatRoom(String roomID) {
    return postsCollection.doc(roomID).snapshots();
  }

  // get stream of course resource documents
  Stream<QuerySnapshot> getDocuments(String school, String courseCode) {
    return documentCollection.doc(school).collection(courseCode).snapshots();
  }

  // get stream of course resource links
  Stream<QuerySnapshot> getLinks(String school, String courseCode) {
    return linkCollection.doc(school).collection(courseCode).snapshots();
  }

  // get stream of user matches
  Stream<QuerySnapshot> userMatches() {
    return studentsCollection.snapshots();
  }

  // get matches and percentage match as a Map
  Future<Map<MyUser, int>> matches(MyUser? user) async {
    Map<MyUser, int> matches = {};

    QuerySnapshot studentQuery = await studentsCollection.get();
    for (var student in studentQuery.docs) {
      Map<String, dynamic> studentData = student.data() as Map<String, dynamic>;
      if ((studentData['school_id'] == user?.school_id) &&
          (studentData['uid'] != user?.uid) &&
          !(user?.connections.keys.contains(studentData['uid']) ?? false)) {
        int percent = 20;
        percent += (studentData['faculty'] == user?.faculty) ? 55 : 0;
        percent += (studentData['department'] == user?.department) ? 20 : 0;
        MyUser match = MyUser()..updateFromMap(studentData);
        matches[match] = percent;
      }
    }
    return matches;
  }

  // update tasks in My Schedule
  Future<void> setTasks(Map<String, dynamic> map) async {
    await studentsCollection
        .doc(uid)
        .collection('schedule_tasks')
        .doc('document')
        .set(map);
  }

  // get tasks
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

  // add a course resource link
  Future<void> addLink(String school, String courseCode, MyLink link) async {
    await linkCollection
        .doc(school)
        .collection(courseCode)
        .add(link.toMap()..addAll({'time': Timestamp.now()}));
  }

  //add a my calendar event
  Future<void> addEvent(Map<String, dynamic> map) async {
    await studentsCollection
        .doc(uid)
        .collection('calendar_events')
        .doc('document')
        .set(map);

    notifyListeners();
  }
  // retrieve events
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

// convert a List<dynamic>, where dynamic is a Map<String, dynamic>, to List<Event>
List<Event> toEvents(List l) {
  return l
      .map(
        (event) => Event(information: '', title: '')
          ..updateFromMap(event as Map<String, dynamic>),
      )
      .toList();
}
