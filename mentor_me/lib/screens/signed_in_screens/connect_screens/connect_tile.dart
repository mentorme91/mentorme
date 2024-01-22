import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/request.dart';
import '../../../models/user.dart';
import 'connect_profile.dart';

class ConnectTile extends StatefulWidget {
  final MyUser user;
  final int percent;
  const ConnectTile({required this.user, required this.percent, super.key});

  @override
  State<ConnectTile> createState() => _ConnectTileState();
}

class _ConnectTileState extends State<ConnectTile> {
  Status _getStatus(MyUser user) {
    List ids = [user.uid, widget.user.uid]..sort();

    String IDkey = ids.join('_');
    if (user.connections.keys.contains(widget.user.uid)) {
      return Status.connected;
    } else if (user.requests.keys.contains(IDkey)) {
      sender = (user.requests[IDkey]?.status == Status.pending)
          ? (user.requests[IDkey]?.senderUID == user.uid)
          : false;
      return user.requests[IDkey]?.status ?? Status.none;
    } else {
      return Status.none;
    }
  }

  bool sender = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Container(
      width: 130,
      height: 150,
      margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => ConnectProfileThemeLoader(
                        sender: sender,
                        status: _getStatus(user ?? MyUser()),
                        match: widget.user,
                      )),
                ),
              );
            },
            child: CircleAvatar(
              radius: 28,
              backgroundImage: (widget.user.photoURL == null)
                  ? const AssetImage('assets/images/face.png')
                  : null,
              foregroundImage: (widget.user.photoURL != null)
                  ? NetworkImage(widget.user.photoURL ?? '', scale: 1)
                  : null,
            ),
          ),
          Text(
            "${widget.user.first_name} ${widget.user.last_name}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            child: Text(
              '${widget.user.department} Major',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 10),
            ),
          ),
          (_getStatus(user ?? MyUser()) == Status.none)
              ? Text(
                  '${widget.percent}% Match',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 12),
                )
              : (_getStatus(user ?? MyUser()) == Status.pending)
                  ? Text(sender ? '' : 'Reply to request')
                  : Text(''),
        ],
      ),
    );
  }
}
