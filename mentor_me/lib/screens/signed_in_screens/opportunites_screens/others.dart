import 'package:flutter/material.dart';
import 'package:mentor_me/screens/signed_in_screens/home_screens/post_form.dart';
import 'package:mentor_me/screens/signed_in_screens/home_screens/post_tile.dart';
import 'package:mentor_me/services/database_service.dart';
import 'package:provider/provider.dart';

import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../theme_provider.dart';

class OtherOpportunitiesPage extends StatefulWidget {
  const OtherOpportunitiesPage({super.key});

  @override
  State<OtherOpportunitiesPage> createState() => _OtherOpportunitiesPageState();
}

class _OtherOpportunitiesPageState extends State<OtherOpportunitiesPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: OtherOpportunities(),
    );
  }
}

class OtherOpportunities extends StatefulWidget {
  const OtherOpportunities({super.key});

  @override
  State<OtherOpportunities> createState() => _OtherOpportunitiesState();
}

class _OtherOpportunitiesState extends State<OtherOpportunities> {
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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.jobPost,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          hintText: AppLocalizations.of(context)!.jobSearch,
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
              future: DatabaseService(uid: '').allPosts('other_posts'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(AppLocalizations.of(context)!.load);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Post> posts = snapshot.data ?? [];
                  return Column(
                    children:
                        posts.map((post) => PostTile(post: post)).toList(),
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _postContent(user, 'other_posts'),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
