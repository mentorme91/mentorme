// This file contains all the helper functions used in this project

import 'package:flutter/material.dart';
import 'package:mentor_me/services/services.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// CreateDropDown: Used to create a custom dropdown from a list of items
List<DropdownMenuItem> createDropDown(List<String> items) {
  return items
      .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
      .toList();
}

// produceList: Generates list of keys from a dictionary
List<String> produceList(Map<String, dynamic> m) {
  List<String> l = [];
  m.forEach((key, value) {
    l.add(key);
  });
  return l;
}

// validates password typed in
String? validatePassword(String? pass) {
  return (pass != '') ? null : 'Enter a valid password';
}

// validates inout text
String? validateText(String? pass, String errorValue) {
  return (pass != '') ? null : errorValue;
}

// initializes the password of a user
void initPassword(MyUser u) {
  u.SetPassword('');
}

// create a custom user class from Firebase user class
Future CreateUserFromAuthUser(User? authUser) async {
  // get a snapshot of all student data
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('all_students')
      .doc(authUser?.uid)
      .get();
  // get student data as a dictionary (Map<String, dynamic>)
  dynamic UserData = snapshot.data;

  // try creating user object from dictionary
  try {
    // return null is user data is null
    if (UserData == null) {
      throw Error();
    }

    // create user instance
    MyUser user = MyUser(
      uid: authUser?.uid,
      email: authUser?.email,
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
    // else return null
    return null;
  }
}
