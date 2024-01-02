import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/services.dart';
import '../../services/helper_methods.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme;
  const HomePage({required this.toggleTheme, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(uid: user?.uid).posts,
      builder: (context, snapshot) {
        // if (snapshot.hasData) {
        //   dynamic posts = snapshot.data ?? {};
        // } else {
        //   dynamic posts = {};
        // }
        // print(user.toString());
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Container(
                  height: 100,
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    radius: 30,
                                    backgroundImage: const AssetImage(
                                        'assets/images/face.png'),
                                    foregroundImage: (user?.photoURL != null)
                                        ? NetworkImage(user?.photoURL ?? '')
                                        : null,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (user?.displayName == null)
                                          ? 'Welcome'
                                          : 'Welcome back',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      user?.displayName ?? 'New user',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(20, 40),
                        ),
                        onPressed: _auth.SignOut,
                        child: Icon(
                          Icons.notifications,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: FractionallySizedBox(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.public,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  size: 50,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Join A',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Community',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => widget.toggleTheme(),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.background,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Text(
                    'Recent Posts',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  ),
                ),
              ] +
              createPostTile(test_posts) +
              [
                SizedBox(
                  height: 30,
                )
              ],
        );
      },
    );
  }
}
