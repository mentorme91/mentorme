// Services module
// Contains relevant services utilized by the app
// 1. The Custom User: Creates a custom user class to ease user data manipulation
// 2. AuthService: Contains methods for user authentication (register and log in)
// 3. DatabaseService: Contains our database servce with methods that are used for our firebase database reading and writing

import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_me/services/helper_methods.dart';

// Custom user class: Contains user information
class MyUser {
  String? uid;
  String? email;
  // String? instituional_email_or_mat_num;
  String? first_name;
  String? last_name;
  String? school_id;
  String? faculty;
  String? department;
  int? year;
  String? _password;
  String? status;
  String? photoURL;
  List<String> connections = [];

  // User constructor
  MyUser({
    this.uid,
    this.email,
    this.first_name,
    this.last_name,
    this.school_id,
    this.faculty,
    this.department,
    this.status,
    this.year,
    this.photoURL,
  });

  // get user password
  String? GetPassword() => _password;
  // set user password
  void SetPassword(String? pass) => _password = pass;

  // still to implement
  Map<String, dynamic> todict() {
    Map<String, dynamic> user_dict = {
      'uid': uid,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'school_id': school_id,
      'faculty': faculty,
      'department': department,
      'status': status,
      'year': year,
      'photoURL': photoURL
    };
    return user_dict;
  }

  String toString() {
    return 'User($first_name $last_name, email: $email, school: $school_id, faculty: $faculty, department: $department)';
  }

  void updateUserFromUser(MyUser user) {
    _password = user.GetPassword();
    uid = user.uid;
    first_name = user.first_name;
    last_name = user.last_name;
    email = user.email;
    school_id = user.school_id;
    faculty = user.faculty;
    department = user.department;
    status = user.status;
    year = user.year;
    photoURL = user.photoURL;
  }
}

MyUser newUser() {
  return MyUser(
    uid: '',
    email: '',
    first_name: '',
    last_name: '',
    school_id: '',
    faculty: '',
    department: '',
    status: '',
    year: 0,
  );
}

// this class control our firebase authentication
class AuthService {
  // This serves as our entry point into firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get changes made to our auth service user
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .asyncMap((event) => CreateUserFromAuthUser(event));
  }

  // method to signin a user using email and password
  Future SignInUser(email, password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return res.user;
    } catch (e) {
      return null;
    }
  }

  // signs out a user
  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  // method to register a user
  Future Register(MyUser user) async {
    try {
      // register user with email and password from firebase auth service and get user credentials
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: user.email ?? '', password: user.GetPassword() ?? '');
      // use user credentials to create an instance of database service for user or update user
      user.uid = res.user?.uid;
      res.user?.updateDisplayName(user.first_name);
      await DatabaseService(uid: res.user?.uid).UpdateStudentCollection(user);
      return res.user;
    } catch (e) {
      // if an error was thrown, return null
      print(e.toString());
      return null;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      print('Error sending password reset email: $e');
      return null;
    }
  }
}

// Database service: controls manipulation of the database
class DatabaseService {
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
  final CollectionReference schoolsCollection =
      FirebaseFirestore.instance.collection('schools');
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat_rooms');

  // update all student collections and student collections in respective schools
  Future UpdateStudentCollection(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.todict() ?? {};
    // update all student collections and student collections in respective schools
    await studentsCollection.doc(user?.uid).set(dic);
    return await schoolsCollection
        .doc(user?.school_id)
        .collection('faculties')
        .doc(user?.faculty)
        .collection('departments')
        .doc(user?.department)
        .collection('students')
        .doc(user?.uid)
        .set(dic);
  }

  // Stream<QuerySnapshot> get students {
  //   return schoolsCollection
  //       .doc(sid)
  //       .collection('faculties')
  //       .doc(fid)
  //       .collection('departments')
  //       .doc(did)
  //       .collection('students')
  //       .snapshots();
  // }

  // get user data snapshots
  Stream<DocumentSnapshot> get userData {
    return studentsCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> get posts {
    return postsCollection.doc('posts').snapshots();
  }

  Stream<DocumentSnapshot> chatRoom(String roomID) {
    return postsCollection.doc(roomID).snapshots();
  }

  Future<Map<MyUser, int>> matches(MyUser? user) async {
    Map<MyUser, int> matches = {};

    QuerySnapshot studentQuery = await studentsCollection.get();
    for (var student in studentQuery.docs) {
      Map<String, dynamic> studentData = student.data() as Map<String, dynamic>;
      if ((studentData['school_id'] == user?.school_id) &&
          (studentData['uid'] != user?.uid)) {
        int percent = 20;
        percent += (studentData['faculty'] == user?.faculty) ? 55 : 0;
        percent += (studentData['department'] == user?.department) ? 20 : 0;
        if (studentData['status'] != user?.status) {
          MyUser match = MyUser(
              uid: studentData['uid'],
              email: studentData['email'],
              first_name: studentData['first_name'],
              last_name: studentData['last_name'],
              school_id: studentData['school_id'],
              faculty: studentData['faculty'],
              department: studentData['department'],
              status: studentData['status'],
              year: studentData['year'],
              photoURL: studentData['photoURL']);
          matches[match] = percent;
        }
      }
    }
    // QuerySnapshot schoolsQuery = await schoolsCollection.get();
    //

    // for (var school in schoolsQuery.docs) {
    //   if (school.id == user?.school_id) {
    //     int percent = 10;
    //     QuerySnapshot facultyQuery =
    //         await school.reference.collection('faculties').get();

    //     for (var faculty in facultyQuery.docs) {
    //       percent += (faculty.id == user?.faculty) ? 20 : 0;
    //       QuerySnapshot deptQuery =
    //           await faculty.reference.collection('departments').get();

    //       for (var dept in deptQuery.docs) {
    //         percent += (dept.id == user?.department) ? 25 : 0;
    //         QuerySnapshot studentsQuery =
    //             await dept.reference.collection('students').get();

    //         for (var student in studentsQuery.docs) {
    //           percent += 30;
    //           if (student.id != user?.uid) {
    //             Map<String, dynamic> studentData =
    //                 student.data() as Map<String, dynamic>;
    //             String? status = user?.status;
    //             if (studentData['status'] != status) {
    //               MyUser match = MyUser(
    //                   uid: studentData['uid'],
    //                   email: studentData['email'],
    //                   first_name: studentData['first_name'],
    //                   last_name: studentData['last_name'],
    //                   school_id: studentData['school_id'],
    //                   faculty: studentData['faculty'],
    //                   department: studentData['deprtment'],
    //                   status: studentData['status'],
    //                   year: studentData['year'],
    //                   photoURL: studentData['photoURL']);
    //               matches[match] == percent;
    //             }
    //           }
    //           percent -= 30;
    //         }
    //         percent -= (dept.id == user?.department) ? 25 : 0;
    //       }
    //       percent -= (faculty.id == user?.faculty) ? 20 : 0;
    //     }
    //   }
    // }
    return matches;
  }
}

Future<String?> captureImage(MyUser user) async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final imageFile = File(pickedFile.path);
    final storage = FirebaseStorage.instance;

    try {
      await storage.ref('images/photoOf${user.uid}.png').putFile(imageFile);
      final imageUrl =
          await storage.ref('images/photoOf${user.uid}.png').getDownloadURL();

      return imageUrl;
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  return null;
}
