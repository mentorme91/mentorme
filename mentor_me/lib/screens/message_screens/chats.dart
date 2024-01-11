import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/chat_service.dart';
import '../profile_screens/detailed_image.dart';
import '../theme_provider.dart';
import 'chat_room.dart';

class ChatsThemeLoader extends StatefulWidget {
  final List<MyUser> connections;
  const ChatsThemeLoader({super.key, required this.connections});

  @override
  State<ChatsThemeLoader> createState() => _ChatsThemeLoaderState();
}

class _ChatsThemeLoaderState extends State<ChatsThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: Chats(
        connections: widget.connections,
      ),
    );
  }
}

class Chats extends StatefulWidget {
  final List<MyUser> connections;
  const Chats({super.key, required this.connections});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  StatelessWidget _connectChatTile(
      MyUser connection, Message lastMessage, MyUser? user) {
    return ListTile(
      onTap: () {
        List ids = [user?.uid, connection.uid]..sort();
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ChatRoomThemeLoader(
                      chatRoom: ids.join('_'), reciever: connection))));
        });
      },
      leading: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(
              image: connection.photoURL,
              uid: connection.uid,
            ),
          ));
        },
        child: Hero(
          tag: 'userImage${connection.uid}',
          child: CircleAvatar(
            backgroundImage: NetworkImage(connection.photoURL ??
                'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
            radius: 35.0,
          ),
        ),
      ),
      title: Text(
        '${connection.first_name} ${connection.last_name}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text((lastMessage.message.length < 25)
          ? lastMessage.message
          : '${lastMessage.message.substring(0, 25)}...'),
      trailing: Text(
          '${lastMessage.time.toDate().hour}:${lastMessage.time.toDate().minute}'),
    );
  }

  List<Widget> _connectionChatTiles(MyUser? user) {
    List<Widget> tiles = [];

    for (var connection in widget.connections) {
      tiles.add(StreamBuilder(
          stream: ChatService()
              .getLastMessageOf(user?.uid ?? '', connection.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error occured!');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            if (snapshot.data!.docs.isNotEmpty) {
              var message =
                  snapshot.data?.docs.first.data() as Map<String, dynamic>;
              var lastMessage = Message(
                message: (user?.uid == message['senderUID'])
                    ? 'You: ${message['message']}'
                    : message['message'],
                senderUID: message['senderUID'],
                recieverUID: message['recieverUID'],
              );
              lastMessage.time = message['time'];
              return _connectChatTile(connection, lastMessage, user);
            }
            return Text('');
          }));
    }
    return tiles;
  }

  String searchVal = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: ([
          Text(
            'Chats',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
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
              borderRadius: BorderRadius.circular(25.0),
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
                      cursorColor: Colors.black,
                      style: const TextStyle(
                        color: Colors.black,
                        decorationColor: Colors.black,
                      ),
                      keyboardType: TextInputType.text,
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
                          hintText: 'Search Chats',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          )),
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
          Column(
            children: _connectionChatTiles(user),
          )
        ])),
      ),
    );
  }
}
