import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentor_me/screens/signed_in_screens/resource_pages/course_bot_chat.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import '../../../models/link.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/storage_service.dart';
import '../../../theme_provider.dart';
import 'document_resources.dart';
import 'link_resources.dart';

class CourseResourcePage extends StatefulWidget {
  final String courseCode;
  const CourseResourcePage({super.key, required this.courseCode});

  @override
  State<CourseResourcePage> createState() => _CourseResourcePageState();
}

class _CourseResourcePageState extends State<CourseResourcePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: CourseResource(
        courseCode: widget.courseCode,
      ),
    );
  }
}

class CourseResource extends StatefulWidget {
  final String courseCode;
  const CourseResource({super.key, required this.courseCode});

  @override
  State<CourseResource> createState() => _CourseResourceState();
}

class _CourseResourceState extends State<CourseResource> {
  int _pageIndex = 0;
  String searchVal = '';

  void _uploadDocument(MyUser? user) async {
    File? file = await StorageService().pickFile();
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              AppLocalizations.of(context)!.noFile,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
      );
      return;
    }
    // } else if (p.extension(file.path) != '.pdf') {
    //   print(file.path);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //         content: Text(
    //           'The file you chose is not a pdf. Please chose a pdf file.',
    //         ),
    //         behavior: SnackBarBehavior.floating,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(30.0))),
    //   );
    //   return;
    // }
    final TextEditingController _titleController = TextEditingController();

    // ignore: use_build_context_synchronously
    String? title = await showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.docTitle),
          content: TextField(
            controller: _titleController,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.title),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                String title = _titleController.text;

                if (title.isNotEmpty) {
                  Navigator.pop(context, title);
                } else {
                  // Show error message or handle invalid input
                }
              },
              child: Text(AppLocalizations.of(context)!.upload),
            ),
          ],
        ),
      ),
    );
    if (title != null) {
      StorageService().uploadDocument(file, title, p.extension(file.path),
          user?.school_id ?? '', widget.courseCode);
    }
    setState(() {});
  }

  void _uploadLink(MyUser? user) async {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _detailsController = TextEditingController();
    final TextEditingController _linkController = TextEditingController();
    MyLink link = MyLink(title: '', details: '', link: '');
    await showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.linkInfo),
          content: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.title),
              ),
              TextField(
                controller: _detailsController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.details),
              ),
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.link),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                link.title = _titleController.text;
                link.details = _detailsController.text;
                link.link = _linkController.text;

                if (link.title.isNotEmpty &&
                    link.link.isNotEmpty &&
                    link.details.isNotEmpty) {
                  Navigator.pop(context);
                } else {
                  // Show error message or handle invalid input
                }
              },
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );

    if (link.title.isEmpty || link.link.isEmpty || link.details.isEmpty) return;
    DatabaseService(uid: '')
        .addLink(user?.school_id ?? '', widget.courseCode, link);
  }

  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.courseCode} ${AppLocalizations.of(context)!.resources}',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (_pageIndex == 0)
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseBotChatPageThemeLoader(
                              courseCode: widget.courseCode),
                        ),
                      );
                    },
                    child: Icon(Icons.android),
                  )
                : SizedBox(),
            FloatingActionButton(
              onPressed: (_pageIndex == 0)
                  ? () => _uploadDocument(user)
                  : () => _uploadLink(user),
              child: Icon(Icons.upload),
            )
          ],
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
                          hintText: AppLocalizations.of(context)!.searchRes,
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
            SizedBox(
              height: 20,
            ),
            (_pageIndex == 0)
                ? DocumentResources(
                    courseCode: widget.courseCode,
                  )
                : LinkResources(
                    courseCode: widget.courseCode,
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) async {
          setState(() {
            _pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.file_copy,
              // color: Colors.black,
              size: 20,
            ),
            label: AppLocalizations.of(context)!.documents,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.link,
              // color: Colors.white,
              size: 20,
            ),
            label: '${AppLocalizations.of(context)!.link}s',
          ),
        ],
      ),
    );
  }
}
