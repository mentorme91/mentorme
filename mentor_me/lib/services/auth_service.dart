import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'database_service.dart';

// this class control our firebase authentication
class AuthService extends ChangeNotifier {
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

  // this function resets a user's password from the forgot password page
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

// create a custom user class from Firebase user class
Future<MyUser?> CreateUserFromAuthUser(User? authUser) async {
  // get a snapshot of all student data
  if (authUser == null) {
    return null;
  }
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('all_students')
      .doc(authUser.uid)
      .get();
  // get student data as a dictionary (Map<String, dynamic>)
  dynamic UserData = snapshot.data();
  // try creating user object from dictionary
  try {
    // return null is user data is null
    if (UserData == null) {
      throw Error();
    }

    // create user instance
    MyUser user = MyUser()..updateFromMap(UserData);
    return user;
  } catch (e) {
    // else return null
    print('Something failed here');
    print(e.toString());
    return null;
  }
}
