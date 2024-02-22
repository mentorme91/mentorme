import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mentor_me/themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/message.dart';
import '../../../../models/request.dart';
import '../../../../models/user.dart';
import '../../../../services/chat_service.dart';
import '../../../../services/database_service.dart';
import '../connect_profile.dart';
import '../../../../theme_provider.dart';

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
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void sendMessage(MyUser? user) async {
    if (_messageController.text.isNotEmpty) {
      Message message = Message(
          message: _messageController.text,
          senderUID: user?.uid ?? '',
          status: AppLocalizations.of(context)!.delivered,
          recieverUID: widget.reciever.uid ?? '');
      user?.connections[widget.reciever.uid ?? ''] = message.time;
      widget.reciever.connections[user?.uid ?? ''] = message.time;
      await DatabaseService(uid: user?.uid).UpdateStudentCollection(user);
      await DatabaseService(uid: widget.reciever.uid)
          .UpdateStudentCollection(widget.reciever);
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
            return Text(AppLocalizations.of(context)!.load);
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document, user))
                .toList(),
          );
        });
  }

  String getDate(String date) {
    if (date == DateFormat('yyyy-MM-dd').format(today)) {
      return AppLocalizations.of(context)!.today;
    }
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (date == DateFormat('yyyy-MM-dd').format(yesterday)) {
      return AppLocalizations.of(context)!.yesterday;
    }
    return date;
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot, MyUser? user) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    var isSender = (data['recieverUID'] == widget.reciever.uid);
    String date = DateFormat('yyyy-MM-dd').format(data['time'].toDate());
    bool dateChange = false;
    if ((day == null) || (day != date)) {
      day = date;
      dateChange = true;
    }
    return Column(
      children: [
        (dateChange)
            ? Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                    child: Text(
                  getDate(date),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              )
            : const SizedBox(),
        Row(
          children: [
            SizedBox(
              width: isSender ? 30 : 0,
            ),
            (!isSender)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.reciever.photoURL ??
                        'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                    radius: 20.0,
                  )
                : Expanded(
                    child: SizedBox(
                      width: 30,
                    ),
                  ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: data['message'].length > (screenWidth / 10)
                  ? ((2 * screenWidth) / 3)
                  : null,
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
              alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    // color: Colors.red,
                    child: Text(
                      data['message'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    // color: Colors.green,
                    child: Text(
                      '${data['time'].toDate().hour.toString().padLeft(2, '0')}:${data['time'].toDate().minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 6,
                      ),
                    ),
                  ),
                ],
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
                : Expanded(
                    child: SizedBox(
                      width: 30,
                    ),
                  ),
            SizedBox(
              width: !isSender ? 30 : 0,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageBox(MyUser? user) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: boxDecoration(Theme.of(context), _borderRadius),
            child: TextFormField(
                maxLines: null,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                controller: _messageController,
                decoration: inputDecoration(Theme.of(context), _borderRadius,
                    AppLocalizations.of(context)!.messageHere)),
          ),
        ),
        IconButton(
            onPressed: () => sendMessage(user),
            icon: Icon(Icons.send_outlined)),
      ],
    );
  }

  String? day;
  DateTime today = DateTime.now();
  final double _borderRadius = 40;

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
                              widget.reciever.first_name ??
                                  AppLocalizations.of(context)!.newUser,
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
        margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(children: [
          Expanded(child: _buildMessageList(user)),
          SizedBox(
            height: 10,
          ),
          _buildMessageBox(user),
        ]),
      ),
    );
  }
}

class ChatBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 16.0;
    final arrowWidth = 10.0;
    final arrowHeight = 10.0;

    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(
        size.width, 0, size.width, radius); // Top right corner

    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius,
        size.height); // Bottom right corner

    // Draw arrow
    path.lineTo(size.width / 2 + arrowWidth / 2, size.height);
    path.lineTo(size.width / 2, size.height + arrowHeight);
    path.lineTo(size.width / 2 - arrowWidth / 2, size.height);

    path.lineTo(radius, size.height);

    path.quadraticBezierTo(
        0, size.height, 0, size.height - radius); // Bottom left corner

    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0); // Top left corner

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
