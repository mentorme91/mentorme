// This file contains all the helper functions used in this project

import 'package:flutter/material.dart';
import 'package:mentor_me/screens/Home_screens/connect_profile.dart';
import 'package:mentor_me/services/services.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final int percent;
  const ConnectTile({required this.user, required this.percent, super.key});

  @override
  State<ConnectTile> createState() => _ConnectTileState();
}

class _ConnectTileState extends State<ConnectTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 150,
      margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ConnectProfileThemeLoader(
                            match: widget.user,
                          ))));
            },
            child: Hero(
              tag: 'matchImage',
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
          ),
          Text(
            "${widget.user.first_name} ${widget.user.last_name}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            child: Text(
              '${widget.user.department} Major',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 10),
            ),
          ),
          (widget.percent != 0)
              ? Text(
                  '${widget.percent}% Match',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 12),
                )
              : Text(''),
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
    MyUser user = MyUser(
      uid: authUser.uid,
      email: authUser.email,
      first_name: UserData['first_name'],
      last_name: UserData['last_name'],
      school_id: UserData['school_id'],
      department: UserData['department'],
      faculty: UserData['faculty'],
      status: UserData['status'],
      year: UserData['year'],
      photoURL: UserData['photoURL'],
    );
    return user;
  } catch (e) {
    // else return null
    return null;
  }
}
