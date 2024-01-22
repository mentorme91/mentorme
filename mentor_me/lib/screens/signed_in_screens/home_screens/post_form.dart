import 'package:flutter/material.dart';

import '../../../models/post.dart';
import '../../../models/user.dart';

class PostFormDialog extends StatefulWidget {
  final MyUser user;
  const PostFormDialog({super.key, required this.user});
  @override
  _PostFormDialogState createState() => _PostFormDialogState();
}

class _PostFormDialogState extends State<PostFormDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create a Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
        ],
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
            String content = _contentController.text;

            if (title.isNotEmpty && content.isNotEmpty) {
              Navigator.pop(
                  context,
                  Post(
                      title: title,
                      content: content,
                      userName:
                          '${widget.user.first_name} ${widget.user.last_name}',
                      userPhotoURL: widget.user.photoURL));
            } else {
              // Show error message or handle invalid input
            }
          },
          child: Text('Post'),
        ),
      ],
    );
  }
}
