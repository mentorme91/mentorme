import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';
import '../../models/request.dart';
import '../../models/user.dart';
import '../../services/chat_service.dart';
import '../Home_screens/connect_profile.dart';
import '../theme_provider.dart';

class ChatRoomThemeLoader extends StatefulWidget {
  final String chatRoom;
  final MyUser reciever;
  const ChatRoomThemeLoader(
      {super.key, required this.chatRoom, required this.reciever});

  @override
  State<ChatRoomThemeLoader> createState() => _ChatRoomThemeLoaderState();
}

class _ChatRoomThemeLoaderState extends State<ChatRoomThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: ChatRoom(
        chatRoom: widget.chatRoom,
        reciever: widget.reciever,
      ),
    );
  }
}

class ChatRoom extends StatefulWidget {
  final String chatRoom;
  final MyUser reciever;
  const ChatRoom({required this.chatRoom, super.key, required this.reciever});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage(MyUser? user) async {
    if (_messageController.text.isNotEmpty) {
      Message message = Message(
          message: _messageController.text,
          senderUID: user?.uid ?? '',
          recieverUID: widget.reciever.uid ?? '');
      await _chatService.sendMessage(message);
      _messageController.clear();
    }
  }

  Widget _buildMessageList(MyUser? user) {
    return StreamBuilder(
        stream: _chatService.recieveMessage(
            user?.uid ?? '', widget.reciever.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error occured!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document, user))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot, MyUser? user) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    var isSender = (data['recieverUID'] == widget.reciever.uid);
    return Row(
      children: [
        (!isSender)
            ? CircleAvatar(
                backgroundImage: NetworkImage(widget.reciever.photoURL ??
                    'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                radius: 20.0,
              )
            : SizedBox(
                width: 30,
              ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: isSender
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  data['message'],
                  style: TextStyle(color: Colors.white),
                  textAlign: isSender ? TextAlign.end : TextAlign.start,
                ),
                Text(
                  '${data['time'].toDate().month}/${data['time'].toDate().day}/${data['time'].toDate().year} at ${data['time'].toDate().hour}:${data['time'].toDate().minute}',
                  textAlign: isSender ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        (isSender)
            ? CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ??
                    'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                radius: 20.0,
              )
            : SizedBox(
                width: 30,
              ),
      ],
    );
  }

  Widget _buildMessageBox(MyUser? user) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              controller: _messageController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    gapPadding: 1,
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: 'Message here...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  )),
            ),
          ),
        ),
        IconButton(
            onPressed: () => sendMessage(user),
            icon: Icon(Icons.send_outlined)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            setState(
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ConnectProfileThemeLoader(
                                      match: widget.reciever,
                                      status: Status.connected,
                                      sender: false,
                                    );
                                  }),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                const AssetImage('assets/images/face.png'),
                            foregroundImage: (widget.reciever.photoURL != null)
                                ? NetworkImage(widget.reciever.photoURL ?? '')
                                : null,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.reciever.first_name ?? 'New user',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(children: [
          Expanded(child: _buildMessageList(user)),
          _buildMessageBox(user),
        ]),
      ),
    );
  }
}
