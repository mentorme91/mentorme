// This file contains all the helper functions used in this project

import 'package:flutter/material.dart';
import 'package:mentor_me/services/services.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, Map<String, dynamic>> test_posts = {
  '1': {
    'photoURL':
        'https://drive.google.com/uc?id=1sU9A3_w1i58aNAkEWNN1KTBKwYqvB9to',
    'userName': 'James Brown',
    'time': '12/31/2023 3:20pm',
    'content': 'Hello world, How are you guys?',
    'likes': 0,
    'comments': 0,
  },
  '2': {
    'photoURL':
        'https://drive.google.com/uc?id=1rFtFKrH_CxIbYcWw-8-uh8H2h0rjLpp-',
    'userName': 'Ruby Rose',
    'time': '12/31/2023 3:20pm',
    'content':
        'Meta is hiring! Use this link -> https://www.androidpolice.com/install-adb-windows-mac-linux-guide/',
    'likes': 0,
    'comments': 0,
  },
  '3': {
    'photoURL': 'https://picsum.photos/250?image=9',
    'userName': 'Mac Daniels',
    'time': '12/31/2023 1:20pm',
    'content':
        'Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?Hello world, we are good and you?',
    'likes': 0,
    'comments': 0,
  },
};

List<MyUser> test_users = [
  MyUser(
      uid: '1',
      email: 'allojeff',
      first_name: 'Jeff',
      last_name: 'Allo',
      school_id: 'Howard',
      faculty: 'CEA',
      department: 'Electrical',
      status: 'Mentor',
      year: 2),
  MyUser(
      uid: '1',
      email: 'allojeff',
      first_name: 'Jeff',
      last_name: 'Allo',
      school_id: 'Howard',
      faculty: 'CEA',
      department: 'Electrical',
      status: 'Mentor',
      year: 2,
      photoURL: 'https://picsum.photos/250?image=9'),
  MyUser(
      uid: '1',
      email: 'allojeff',
      first_name: 'Jeff',
      last_name: 'Allo',
      school_id: 'Howard',
      faculty: 'CEA',
      department: 'Electrical',
      status: 'Mentor',
      year: 2),
  MyUser(
      uid: '1',
      email: 'allojeff',
      first_name: 'Jeff',
      last_name: 'Allo',
      school_id: 'Howard',
      faculty: 'CEA',
      department: 'Electrical',
      status: 'Mentor',
      year: 2),
  MyUser(
      uid: '1',
      email: 'allojeff',
      first_name: 'Jeff',
      last_name: 'Allo',
      school_id: 'Howard',
      faculty: 'CEA',
      department: 'Electrical',
      status: 'Mentor',
      year: 2),
  MyUser(
      uid: '1',
      email: 'allojeff',
      first_name: 'Jeff',
      last_name: 'Allo',
      school_id: 'Howard',
      faculty: 'CEA',
      department: 'Electrical',
      status: 'Mentor',
      year: 2),
];

// CreatePostTile: Used to create a post tile
List<Widget> createPostTile(Map<String, Map<String, dynamic>> postInfo) {
  List<Widget> postTiles = [];
  postInfo.forEach((key, value) {
    postTiles.add(PostTile(postInfo: value));
  });
  return postTiles;
}

class ConnectTile extends StatefulWidget {
  final MyUser user;
  const ConnectTile({required this.user, super.key});

  @override
  State<ConnectTile> createState() => _ConnectTileState();
}

class _ConnectTileState extends State<ConnectTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 140,
      margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
      padding: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).shadowColor,
        //     spreadRadius: 5,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3), // changes the position of the shadow
        //   ),
        // ],
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 0.2,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => {},
            child: CircleAvatar(
              radius: 28,
              backgroundImage: (widget.user.photoURL == null)
                  ? const AssetImage('assets/images/face.png')
                  : null,
              foregroundImage: (widget.user.photoURL != null)
                  ? NetworkImage(widget.user.photoURL ?? '', scale: 1)
                  : null,
            ),
          ),
          Text(
            "${widget.user.first_name} ${widget.user.last_name}",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
          ),
          Text(
            '${widget.user.department} Major',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
          )
        ],
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  final Map<String, dynamic> postInfo;

  const PostTile({required this.postInfo});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool bookmarkTapped = false;

  bool likeTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
      padding: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 0.2,
        ),
        color: Theme.of(context).colorScheme.surface,
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
                                (widget.postInfo['photoURL'] == null)
                                    ? const AssetImage('assets/images/face.png')
                                    : null,
                            foregroundImage:
                                (widget.postInfo['photoURL'] != null)
                                    ? NetworkImage(
                                        widget.postInfo['photoURL'] ?? '',
                                        scale: 1)
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.postInfo['time'],
                              style: const TextStyle(
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
              const IconButton(onPressed: null, icon: Icon(Icons.menu))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.postInfo['content'],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            widget.postInfo['likes'].toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            onPressed: () => {
                              setState(() {
                                likeTapped = !likeTapped;
                                widget.postInfo['likes'] += likeTapped ? 1 : -1;
                              })
                            },
                            icon: Icon(
                              Icons.thumb_up,
                              color: likeTapped
                                  ? const Color.fromARGB(255, 56, 107, 246)
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            widget.postInfo['comments'].toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.chat_rounded,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            bookmarkTapped = !bookmarkTapped;
                          })
                        },
                    icon: Icon(
                      Icons.bookmark,
                      color: bookmarkTapped ? Colors.yellow : Colors.grey,
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
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
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
