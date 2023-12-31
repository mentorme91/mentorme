// This file contains all the helper functions used in this project

import 'package:flutter/material.dart';
import 'package:mentor_me/services/services.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, Map<String, dynamic>> posts = {
  '1': {
    'photURL': null,
    'userName': 'James Brown',
    'time': '12/31/2023 3:20pm',
    'content': 'Hello world, How are you guys?',
    'likes': 0,
    'comments': 0,
  },
  '2': {
    'photURL': null,
    'userName': 'Mac Daniels',
    'time': '12/31/2023 1:20pm',
    'content':
        'Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?',
    'likes': 0,
    'comments': 0,
  },
};

// CreatePostTile: Used to create a post tile
List<Widget> createPostTile(Map<String, Map<String, dynamic>> postInfo) {
  List<Widget> postTiles = [];
  postInfo.forEach((key, value) {
    postTiles.add(PostTile(postInfo: value));
  });
  return postTiles;
}

class PostTile extends StatefulWidget {
  final Map<String, dynamic> postInfo;

  const PostTile({required this.postInfo});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool bookmark_tapped = false;

  bool like_tapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 20, right: 20),
      padding: EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 10,
            blurRadius: 10,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 0.2,
        ),
        color: Color.fromRGBO(83, 86, 255, 0.094),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => {},
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage('assets/images/Logo2.png'),
                            foregroundImage:
                                (widget.postInfo['photoURL'] != null)
                                    ? NetworkImage(
                                        widget.postInfo['photoURL'] ?? '')
                                    : null,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.postInfo['userName'] ?? 'User',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.postInfo['time'],
                              style: TextStyle(
                                color: Color.fromARGB(255, 87, 87, 87),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: null, icon: Icon(Icons.menu))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.postInfo['content'],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Row(
                        children: [
                          Text(widget.postInfo['likes'].toString()),
                          IconButton(
                            onPressed: () => {
                              setState(() {
                                like_tapped = !like_tapped;
                              })
                            },
                            icon: Icon(
                              Icons.thumb_up,
                              color: like_tapped
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                          Text(widget.postInfo['comments'].toString()),
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(Icons.chat_rounded),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            bookmark_tapped = !bookmark_tapped;
                          })
                        },
                    icon: Icon(
                      Icons.bookmark,
                      color: bookmark_tapped ? Colors.yellow : Colors.grey,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
