import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/post.dart';

class PostTile extends StatefulWidget {
  final Post post;

  const PostTile({required this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool bookmarkTapped = false;

  bool likeTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
      padding: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 0.2,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => {},
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: (widget.post.userPhotoURL == null)
                                ? const AssetImage('assets/images/face.png')
                                : null,
                            foregroundImage: (widget.post.userPhotoURL != null)
                                ? NetworkImage(widget.post.userPhotoURL ?? '',
                                    scale: 1)
                                : null,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.userName ?? 'User',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(widget.post.time.toDate())
                                  .toString(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 87, 87, 87),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const IconButton(onPressed: null, icon: Icon(Icons.menu))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.post.content ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            widget.post.likes.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            onPressed: () => {
                              setState(() {
                                likeTapped = !likeTapped;
                                widget.post.likes += likeTapped ? 1 : -1;
                              })
                            },
                            icon: Icon(
                              Icons.thumb_up,
                              color: likeTapped
                                  ? const Color.fromARGB(255, 56, 107, 246)
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            widget.post.comments.length.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.chat_rounded,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            bookmarkTapped = !bookmarkTapped;
                          })
                        },
                    icon: Icon(
                      Icons.bookmark,
                      color: bookmarkTapped ? Colors.yellow : Colors.grey,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
