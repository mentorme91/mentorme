import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/link.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../themes.dart';

class LinkResources extends StatefulWidget {
  final String courseCode;
  const LinkResources({super.key, required this.courseCode});

  @override
  State<LinkResources> createState() => _LinkResourcesState();
}

class _LinkResourcesState extends State<LinkResources> {
  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService(uid: '')
            .getLinks(user?.school_id ?? '', widget.courseCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final documents = snapshot.data?.docs ?? [];
          return Container(
            height: MediaQuery.of(context).size.height - 260,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                MyLink link = MyLink(
                  title: document['title'] as String,
                  details: document['details'] as String,
                  link: document['link'] as String,
                );
                // Timestamp time = document['time'] as Timestamp;
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: boxDecoration(Theme.of(context), 20),
                  child: ListTile(
                    title: Text(link.title),
                    subtitle: Column(
                      children: [
                        Text('Details: ${link.details}'),
                        InkWell(
                          onTap: () => launchUrl(Uri.parse(link.link)),
                          child: Text(
                            'https://mntrme/${generateRandomCharacters(7)}',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

String generateRandomCharacters(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String result = '';

  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(characters.length);
    result += characters[randomIndex];
  }

  return result;
}
