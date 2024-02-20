import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/request.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'message_screens/chat_room.dart';
import '../home_screens/profile_screens/detailed_image.dart';
import '../../../theme_provider.dart';

class ConnectProfileThemeLoader extends StatefulWidget {
  final MyUser match;
  final Status status;
  final bool sender;
  const ConnectProfileThemeLoader(
      {super.key,
      required this.match,
      required this.status,
      required this.sender});

  @override
  State<ConnectProfileThemeLoader> createState() =>
      _ConnectProfileThemeLoaderState();
}

class _ConnectProfileThemeLoaderState extends State<ConnectProfileThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: ConnectProfile(
        sender: widget.sender,
        status: widget.status,
        match: widget.match,
      ),
    );
  }
}

class ConnectProfile extends StatefulWidget {
  final MyUser match;
  final bool sender;
  final Status status;
  const ConnectProfile(
      {super.key,
      required this.match,
      required this.status,
      required this.sender});

  @override
  State<ConnectProfile> createState() => _ConnectProfileState();
}

class _ConnectProfileState extends State<ConnectProfile> {
  void _pushChat(MyUser? user) {
    List ids = [user?.uid, widget.match.uid]..sort();
    String room = ids.join('_');
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => ChatRoomThemeLoader(
                chatRoom: room,
                reciever: widget.match,
              )),
        ),
      );
    });
  }

  Future<void> _acceptConnectRequest(MyUser? user) async {
    List ids = [user?.uid, widget.match.uid]..sort();
    user?.requests.remove(ids.join('_'));
    widget.match.requests.remove(ids.join('_'));
    user?.connections.addAll({widget.match.uid ?? '': null});
    widget.match.connections.addAll({user?.uid ?? '': null});
    await DatabaseService(uid: '').UpdateStudentCollection(user);
    await DatabaseService(uid: '').UpdateStudentCollection(widget.match);
    setState(() {
      show = null;
    });
  }

  Future<void> _rejectConnectRequest(MyUser? user) async {
    List ids = [user?.uid, widget.match.uid]..sort();
    user?.requests.remove(ids.join('_'));
    widget.match.requests.remove(ids.join('_'));
    user?.rejects.add(widget.match.uid ?? '');
    widget.match.rejects.add(user?.uid ?? '');
    await DatabaseService(uid: '').UpdateStudentCollection(user);
    await DatabaseService(uid: '').UpdateStudentCollection(widget.match);
    setState(() {
      show = null;
    });
  }

  Future<void> _cancelConnectRequest(MyUser? user) async {
    List ids = [user?.uid, widget.match.uid]..sort();
    user?.requests.remove(ids.join('_'));
    widget.match.requests.remove(ids.join('_'));
    user?.cancels.add(widget.match.uid ?? '');
    await DatabaseService(uid: '').UpdateStudentCollection(user);
    await DatabaseService(uid: '').UpdateStudentCollection(widget.match);

    setState(() {
      show = 'canceled';
    });
  }

  Future<void> _sendConnectRequest(MyUser? user) async {
    if (user == null) {
      return;
    }
    Request request = Request(
        recieverUID: widget.match.uid,
        senderUID: user.uid,
        status: Status.pending);
    List ids = [user.uid, widget.match.uid]..sort();

    user.requests[ids.join('_')] = request;
    widget.match.requests[ids.join('_')] = request;
    await DatabaseService(uid: '').UpdateStudentCollection(user);
    await DatabaseService(uid: '').UpdateStudentCollection(widget.match);
    setState(() {
      show = null;
      status = Status.pending;
    });
  }

  List<Widget> _getChildren(MyUser? user) {
    List<Widget> children = [];
    if (user?.connections.keys.contains(widget.match.uid) ?? false) {
      children.add(
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 50)),
          ),
          onPressed: () async {
            _pushChat(user);
          },
          child: const Text(
            'Message',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (user?.cancels.contains(widget.match.uid) ?? false) {
      children.add(const Text('You can reconnect only after 30 days'));
    } else if (user?.rejects.contains(widget.match.uid) ?? false) {
      children.add(const Text('You can reconnect only after 30 days'));
    } else if (widget.status == Status.pending) {
      List ids = [user?.uid, widget.match.uid]..sort();
      if (user?.uid == user?.requests[ids.join('_')]?.senderUID) {
        children.add(
          TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 241, 64, 51)),
              padding: MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 50)),
            ),
            onPressed: () async {
              _cancelConnectRequest(user);
            },
            child: const Text(
              'Cancel Request',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        children.add(
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Theme.of(context).primaryColor),
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 50)),
            ),
            onPressed: () async {
              _acceptConnectRequest(user);
            },
            child: const Text(
              'Accept',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        );
        children.add(
          TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 241, 64, 51)),
              padding: MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 50)),
            ),
            onPressed: () async {
              _rejectConnectRequest(user);
            },
            child: const Text(
              'Reject',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } else if (status == Status.none) {
      children.add(
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 50)),
          ),
          onPressed: () async {
            _sendConnectRequest(user);
          },
          child: const Text(
            'Connect',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      children.add(Text('Request sent successfully!'));
    }

    return children;
  }

  String? show;
  Status status = Status.none;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    image: widget.match.photoURL,
                    uid: widget.match.uid,
                  ),
                ));
              },
              child: Hero(
                tag: 'userImage${widget.match.uid}',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.match.photoURL ??
                      'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                  radius: 60.0,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${widget.match.first_name} ${widget.match.last_name}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '${widget.match.department} Major',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'About',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${widget.match.about}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _getChildren(user),
            ),
          ],
        ),
      ),
    );
  }
}
