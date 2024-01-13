import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentor_me/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan(
      {required TextStyle style, required String url, required String text})
      : super(
            style: style,
            text: text,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri(path: url));
              });
}

class DocumentResources extends StatefulWidget {
  final String courseCode;
  const DocumentResources({super.key, required this.courseCode});

  @override
  State<DocumentResources> createState() => _DocumentResourcesState();
}

class _DocumentResourcesState extends State<DocumentResources> {
  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService(uid: '')
            .getDocuments(user?.school_id ?? '', widget.courseCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final documents = snapshot.data?.docs ?? [];
          print(snapshot.data?.docs);
          return Container(
            height: MediaQuery.of(context).size.height - 260,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                final title = document['title'] as String;
                final url = document['url'] as String;
                print(url);
                return ListTile(
                  title: Text(title),
                  subtitle: RichText(
                    text: LinkTextSpan(
                        url: url, text: 'Display file', style: TextStyle()),
                  ),
                  onTap: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
