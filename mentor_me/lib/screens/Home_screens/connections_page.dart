import 'package:flutter/material.dart';
import 'package:mentor_me/screens/Home_screens/connect_request.dart';
import 'package:mentor_me/services/helper_methods.dart';
import 'package:provider/provider.dart';
import '../../services/services.dart';

class ConnectionsPage extends StatefulWidget {
  final Map<MyUser, int> matches;
  final List<MyUser> connections;
  const ConnectionsPage(
      {required this.matches, super.key, required this.connections});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  String searchVal = '';
  List<Map<MyUser, int>> matches = [];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Connections',
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
              color: Colors.white,
              // border: Border.all(
              //   color: Color.fromARGB(255, 56, 107, 246),
              //   width: 0.3,
              // ),
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
                          hintText: 'Search Connections',
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
            height: 15,
          ),
          ListTile(
            title: Text('See connect requests'),
            trailing: Icon(Icons.arrow_right_alt),
            tileColor: Theme.of(context).colorScheme.surface,
            onTap: () async {
              List<MyUser> recievedRequests = [];
              List<MyUser> sentRequests = [];
              if (user != null) {
                for (var request in user.requests.values) {
                  if (request.status == Status.pending) {
                    if (request.recieverUID == user.uid) {
                      MyUser requestUser =
                          await DatabaseService(uid: request.senderUID)
                              .userInfo;
                      recievedRequests.add(requestUser);
                    } else if (request.senderUID == user.uid) {
                      MyUser requestUser =
                          await DatabaseService(uid: request.recieverUID)
                              .userInfo;
                      sentRequests.add(requestUser);
                    }
                  }
                }
              }
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (((context) => RequestsPageThemeLoader(
                          recievedRequests: recievedRequests,
                          sentRequests: sentRequests,
                        ))),
                  ),
                );
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              'Your Matches',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.matches.keys
                    .map((user) => ConnectTile(
                          user: user,
                          percent: widget.matches[user] ?? 0,
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Your Connections',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.connections
                    .map((user) => ConnectTile(
                          user: user,
                          percent: 0,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
