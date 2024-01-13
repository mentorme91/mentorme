import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../services/storage_service.dart';
import '../../theme_provider.dart';
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
    final TextEditingController _titleController = TextEditingController();

    // ignore: use_build_context_synchronously
    String title = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter document title'),
        content: TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
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
            child: Text('Upload'),
          ),
        ],
      ),
    );
    StorageService().uploadDocument(
        file, title, 'pdf', user?.school_id ?? '', widget.courseCode);
    setState(() {});
  }

  void _uploadLink() {}
  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed:
            (_pageIndex == 0) ? () => _uploadDocument(user) : _uploadLink,
        child: Icon(Icons.upload),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                '${widget.courseCode} Resources',
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
                          hintText: 'Search for a resource',
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.file_copy,
              // color: Colors.black,
              size: 20,
            ),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.link,
              // color: Colors.white,
              size: 20,
            ),
            label: 'Links',
          ),
        ],
      ),
    );
  }
}
