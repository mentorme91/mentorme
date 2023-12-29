import 'package:flutter/material.dart';
// import 'dart:html';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';

const schools_id = {
  'Howard University': 'x3xptJcAjCdFPLGgMNxG',
};

const schools_factulties = {
  'Howard University': ['Others'],
};

const faculties_dept = {
  'Others': ['mist'],
};

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

  // User constructor
  MyUser({
    required this.uid,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.school_id,
    required this.faculty,
    required this.department,
    required this.status,
    required this.year,
  });

  // get user password
  String? GetPassword() => _password;
  // set user password
  void SetPassword(String? pass) => _password = pass;

  // still to implement
  Map<String, dynamic> todict() {
    Map<String, dynamic> user_dict = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'school_id': school_id,
      'faculty': faculty,
      'department': department,
      'status': status,
      'year': year,
    };
    return user_dict;
  }
}

// create a custom user class from Firebase user class
Future CreateUserFromAuthUser(User? AuthUser) async {
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('all_students')
      .doc(AuthUser?.uid)
      .get();

  dynamic UserData = snapshot.data;
  try {
    if (UserData == null) {
      throw Error();
    }
    MyUser user = MyUser(
      uid: AuthUser?.uid,
      email: AuthUser?.email,
      first_name: UserData['first_name'],
      last_name: UserData['last_name'],
      school_id: UserData['sid'],
      department: UserData['department'],
      faculty: UserData['faculty'],
      status: UserData['status'],
      year: UserData['year'],
    );
    return user;
  } catch (e) {
    return null;
  }
}

// this class control our firebase authentication
class AuthService {
  // This serves as our entry point into firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get changes made to our auth service user
  Stream<User?> get user {
    return _auth.authStateChanges();
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
  Future Register(String email, String password, String name, String major,
      String clasification) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DatabaseService(uid: res.user?.uid)
          .UpdateStudentCollection(await CreateUserFromAuthUser(
        res.user,
      ));
      return res.user;
    } catch (e) {
      return null;
    }
  }
}

class DatabaseService {
  final String? uid;

  DatabaseService({
    required this.uid,
  });

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('all_students');
  final CollectionReference schoolsCollection =
      FirebaseFirestore.instance.collection('schools');

  Future UpdateStudentCollection(MyUser? user) async {
    Map<String, dynamic> dic = user?.todict() ?? {};
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

  Stream<DocumentSnapshot> get userData {
    return studentsCollection.doc(uid).snapshots();
  }
}
