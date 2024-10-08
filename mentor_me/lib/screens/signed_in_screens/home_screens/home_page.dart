import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'comminuties_screens/communities.dart';
import 'post_tile.dart';
import 'profile_screens/notifications.dart';
import 'profile_screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
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
                                onPressed: () async {
                                  setState(
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return UserProfile();
                                        }),
                                      );
                                    },
                                  );
                                },
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
                                    (user?.first_name == null)
                                        ? AppLocalizations.of(context)!.welcome
                                        : AppLocalizations.of(context)!.back,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    user?.first_name ?? 'New user',
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
                        minimumSize: const Size(20, 40),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsThemeLoader()));
                        });
                      },
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunitiesPageThemeLoader()),
                    );
                  });
                },
                child: Container(
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
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.public,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.join,
                                    style: const TextStyle(
                                      // color: Theme.of(context)
                                      //     .colorScheme
                                      //     .background,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.community,
                                    style: const TextStyle(
                                      // color: Theme.of(context)
                                      //     .colorScheme
                                      //     .background,
                                      color: Colors.white,
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
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CommunitiesPageThemeLoader()),
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  AppLocalizations.of(context)!.post,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
              FutureBuilder<List<Post>>(
                  future: DatabaseService(uid: '').allPosts('admin_posts'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(AppLocalizations.of(context)!.load);
                    } else if (snapshot.hasError) {
                      return Text('An Error occurred');
                    } else {
                      List<Post> posts = snapshot.data ?? [];
                      return Column(
                        children:
                            posts.map((post) => PostTile(post: post)).toList(),
                      );
                    }
                  }),
            ]);
      },
    );
  }
}
