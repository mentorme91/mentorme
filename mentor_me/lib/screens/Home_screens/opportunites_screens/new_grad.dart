import 'package:flutter/material.dart';
import 'package:mentor_me/screens/post_form.dart';
import 'package:mentor_me/screens/post_tile.dart';
import 'package:mentor_me/services/database_service.dart';
import 'package:provider/provider.dart';

import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../theme_provider.dart';

class NewGradRolesPage extends StatefulWidget {
  const NewGradRolesPage({super.key});

  @override
  State<NewGradRolesPage> createState() => _NewGradRolesPageState();
}

class _NewGradRolesPageState extends State<NewGradRolesPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: NewGradRoles(),
    );
  }
}

class NewGradRoles extends StatefulWidget {
  const NewGradRoles({super.key});

  @override
  State<NewGradRoles> createState() => _NewGradRolesState();
}

class _NewGradRolesState extends State<NewGradRoles> {
  String searchVal = '';

  void _postContent(MyUser? user, String postType) async {
    Post? newPost = await showDialog<Post>(
      context: context,
      builder: (context) => PostFormDialog(user: user ?? MyUser()),
    );
    if (newPost != null) {
      DatabaseService(uid: '').postNewPost(newPost, postType);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(
              'New grad roles posts',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.only(
              left: 10,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            alignment: AlignmentDirectional.center,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () => {print('Hello!')},
                ),
                Expanded(
                  child: FractionallySizedBox(
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Search for a new grad role',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchVal = value;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder<List<Post>>(
            future: DatabaseService(uid: '').allPosts('new_gard_posts'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Post> posts = snapshot.data ?? [];
                return Column(
                  children: posts.map((post) => PostTile(post: post)).toList(),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _postContent(user, 'new_grad_posts'),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
