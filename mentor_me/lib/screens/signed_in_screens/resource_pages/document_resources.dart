import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libre_doc_converter/libre_doc_converter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/storage_service.dart';
import '../../../themes.dart';
import 'pdf_viewer.dart';

class DocumentResources extends StatefulWidget {
  final String courseCode;
  const DocumentResources({super.key, required this.courseCode});

  @override
  State<DocumentResources> createState() => _DocumentResourcesState();
}

class _DocumentResourcesState extends State<DocumentResources> {
  Map extensionImage = {'.pdf': 'pdf.png', '.docx': 'docx.jpeg'};
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
                final path = document['path'] as String;
                final url = document['url'] as String;
                final extension = document['type'] as String;
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: boxDecoration(Theme.of(context), 20),
                  child: ListTile(
                      title: Text(title),
                      subtitle: Text(
                        'Tap to view file',
                        style: TextStyle(color: Colors.blue),
                      ),
                      leading: Image.asset(
                          'assets/images/${extensionImage[extension] ?? 'pdf.png'}'),
                      trailing: IconButton(
                        onPressed: () async {
                          bool pass =
                              await StorageService().downloadFile(path, title);
                          if (pass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                    'File $title successfully downloaded in downloads folder!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                    'File $title failed to download!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                            );
                          }
                        },
                        icon: Icon(Icons.download),
                      ),
                      onTap: () async {
                        final file = await StorageService()
                            .loadFirebaseFile(path, title);
                        if (file == null) return;
                        if (extension == '.pdf') {
                          setState(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PDFViewerPage(
                                  file: file,
                                  title: title,
                                ),
                              ),
                            );
                          });
                        } else {
                          print(file.path);
                          final converter = LibreDocConverter(
                            inputFile: file,
                          );

                          try {
                            final pdfFile = await converter.toPdf();
                            setState(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PDFViewerPage(
                                  file: pdfFile,
                                  title: title,
                                ),
                              ),
                            );
                          });
                          } catch (e) {
                            print(e.toString());
                            launchUrl(Uri.parse(url));
                          }
                        }
                      }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
