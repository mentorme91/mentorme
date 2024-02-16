import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:provider/provider.dart';

import '../../../models/bot_message.dart';
import '../../../models/user.dart';
import '../../../services/bot_service.dart';
import '../../../theme_provider.dart';
import '../../../themes.dart';

class CourseBotChatPageThemeLoader extends StatefulWidget {
  final String courseCode;
  const CourseBotChatPageThemeLoader({super.key, required this.courseCode});

  @override
  State<CourseBotChatPageThemeLoader> createState() =>
      _CourseBotChatPageThemeLoaderState();
}

class _CourseBotChatPageThemeLoaderState
    extends State<CourseBotChatPageThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: CourseBotChatPage(
        course: widget.courseCode,
      ),
    );
  }
}

class CourseBotChatPage extends StatefulWidget {
  final String course;
  const CourseBotChatPage({super.key, required this.course});

  @override
  State<CourseBotChatPage> createState() => _CourseBotChatPageState();
}

class _CourseBotChatPageState extends State<CourseBotChatPage> {
  late MyUser? user;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? day;
  DateTime today = DateTime.now();
  final double _borderRadius = 40;
  bool thinking = false;

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 2),
      curve: Curves.easeIn,
    );
  }

  void askBotQuestion() async {
    if (_messageController.text.isNotEmpty) {
      BotMessage message =
          BotMessage(message: _messageController.text, isBot: false);

      await BotService(courseCode: widget.course, uid: user?.uid ?? '')
          .addMessage(message);
      _messageController.clear();
      setState(() {
        thinking = true;
      });
      String url =
          'https://07f8-2601-152-b01-1550-f801-8bd1-8ea4-81ed.ngrok-free.app/api?Query=${message.message}';
      var decodedData;
      try {
        String data = await getData(url);
        decodedData = jsonDecode(data);
      } catch (e) {
        decodedData = {'response': 'Oops! An error occurred :('};
      }

      setState(() {
        thinking = false;
      });
      BotMessage botMessage =
          BotMessage(message: decodedData['response'], isBot: true);
      await BotService(courseCode: widget.course, uid: user?.uid ?? '')
          .addMessage(botMessage);
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: BotService(courseCode: widget.course, uid: user?.uid ?? '')
            .getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error occured!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                    .map((document) => _buildMessageItem(document, user))
                    .toList() +
                [
                  thinking ? Text('Thinking...') : SizedBox(),
                ],
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot, MyUser? user) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    var isBot = data['isBot'] ?? false;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: !isBot ? 30 : 0,
            ),
            (isBot)
                ? CircleAvatar(
                    child: Icon(Icons.android),
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
                color: isBot
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              alignment: isBot ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: data['message'].length > (screenWidth / 12)
                          ? ((2 * screenWidth) / 3)
                          : (data['message'].length / 6) * 47,
                      alignment: Alignment.topLeft,
                      // color: Colors.red,
                      child: TeXView(
                        child: TeXViewDocument(
                          data['message'],
                          style: TeXViewStyle(contentColor: Theme.of(context).colorScheme.background,)
                        ),
                        renderingEngine: TeXViewRenderingEngine.katex(),
                      ),
                      // child: Text(

                      //   data['message'],
                      //   style: TextStyle(color: Colors.white, fontSize: 12),
                      //   textAlign: TextAlign.start,
                      // ),
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
            (!isBot)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.photoURL ??
                          'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ',
                    ),
                    radius: 20.0,
                  )
                : Expanded(
                    child: SizedBox(
                      width: 30,
                    ),
                  ),
            SizedBox(
              width: isBot ? 30 : 0,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMessageBox() {
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
                decoration: inputDecoration(
                    Theme.of(context), _borderRadius, 'Message here...')),
          ),
        ),
        IconButton(
            onPressed: () => askBotQuestion(), icon: Icon(Icons.send_outlined)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          child: Icon(Icons.android),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Column(children: [
          Expanded(
            child: _buildMessageList(),
          ),
          SizedBox(
            height: 10,
          ),
          buildMessageBox(),
        ]),
      ),
    );
  }
}
