import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../models/message.dart';
import '../../../../models/user.dart';
import '../../../../services/chat_service.dart';
import '../../../../services/database_service.dart';
import '../../home_screens/profile_screens/detailed_image.dart';
import '../../../../theme_provider.dart';
import 'chat_room.dart';

List<String> _getSortedKeysWithTimestamp(Map<String, Timestamp?> connections) {
  List<String> keysWithTimestamp = [];

  // Filter keys with non-null timestamp
  connections.forEach((key, timestamp) {
    if (timestamp != null) {
      keysWithTimestamp.add(key);
    }
  });

  // Sort keys based on timestamp
  keysWithTimestamp.sort((a, b) {
    Timestamp timestampA = connections[a]!;
    Timestamp timestampB = connections[b]!;
    return timestampB.compareTo(timestampA);
  });

  return keysWithTimestamp;
}

class ChatsThemeLoader extends StatefulWidget {
  const ChatsThemeLoader({super.key});

  @override
  State<ChatsThemeLoader> createState() => _ChatsThemeLoaderState();
}

class _ChatsThemeLoaderState extends State<ChatsThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: Chats(),
    );
  }
}

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  StatelessWidget _connectChatTile(
      MyUser connection, Message lastMessage, MyUser? user, ThemeData theme) {
    return ListTile(
      // tileColor: theme.colorScheme.surface,
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
      subtitle: Text(
        lastMessage.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(getTime(lastMessage.time.toDate())),
    );
  }

  String getTime(DateTime day) {
    DateTime today = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(day);
    if (date == DateFormat('yyyy-MM-dd').format(today)) {
      return '${day.hour.toString().padLeft(2, '0')}:${day.minute.toString().padLeft(2, '0')}';
    }
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (date == DateFormat('yyyy-MM-dd').format(yesterday)) {
      return AppLocalizations.of(context)!.yesterday;
    }
    return date;
  }

  List<Widget> _connectionChatTiles(
      MyUser? user, ThemeData theme, List<MyUser> connections) {
    List<Widget> tiles = [];
    List<Timestamp> times = [];

    for (var connection in connections) {
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
            if (snapshot.data!.docChanges.length != 0) {
              var message =
                  snapshot.data?.docs.first.data() as Map<String, dynamic>;
              var lastMessage = Message(
                status: message['status'] ?? 'seen',
                message: (user?.uid == message['senderUID'])
                    ? 'You: ${message['message']}'
                    : message['message'],
                senderUID: message['senderUID'],
                recieverUID: message['recieverUID'],
              );
              lastMessage.time = message['time'];
              times.add(lastMessage.time);
              return _connectChatTile(connection, lastMessage, user, theme);
            }
            return Text('');
          }));
    }
    return tiles;
  }

  Future<List<MyUser>> _getConnections(MyUser? user) async {
    List<String> ids = _getSortedKeysWithTimestamp(user?.connections ?? {});
    List<MyUser> connections = [];
    for (var connectionId in ids) {
      MyUser u = await DatabaseService(uid: connectionId).userInfo;
      connections.add(u);
    }
    return connections;
  }

  String searchVal = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          AppLocalizations.of(context)!.chats,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: ([
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
                        hintText: AppLocalizations.of(context)!.searchChats,
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
          FutureBuilder<List<MyUser>>(
            future: _getConnections(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(AppLocalizations.of(context)!.load);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<MyUser> connections = snapshot.data ?? [];
                return Column(
                  children: _connectionChatTiles(
                      user, Theme.of(context), connections),
                );
              }
            },
          ),
        ])),
      ),
    );
  }
}
