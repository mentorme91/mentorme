import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/storage_service.dart';
import 'pdf_viewer.dart';

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
          return Container(
            height: MediaQuery.of(context).size.height - 260,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                final title = document['title'] as String;
                final url = document['path'] as String;
                return ListTile(
                    title: Text(title),
                    subtitle: Text('Tap to Display file'),
                    onTap: () async {
                      final file =
                          await StorageService().loadFirebaseFile(url, title);
                      if (file == null) return;
                      setState(() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PDFViewerPage(
                                  file: file,
                                  title: title,
                                )));
                      });
                    });
              },
            ),
          );
        },
      ),
    );
  }
}
