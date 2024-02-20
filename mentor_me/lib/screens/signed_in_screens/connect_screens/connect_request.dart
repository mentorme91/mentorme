import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/user.dart';
import 'connect_tile.dart';
import '../../../theme_provider.dart';

class RequestsPageThemeLoader extends StatefulWidget {
  final List<MyUser> recievedRequests;
  final List<MyUser> sentRequests;
  const RequestsPageThemeLoader(
      {super.key, required this.recievedRequests, required this.sentRequests});

  @override
  State<RequestsPageThemeLoader> createState() =>
      _RequestsPageThemeLoaderState();
}

class _RequestsPageThemeLoaderState extends State<RequestsPageThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
        data: theme,
        child: RequestsPage(
          recievedRequests: widget.recievedRequests,
          sentRequests: widget.sentRequests,
        ));
  }
}

class RequestsPage extends StatefulWidget {
  final List<MyUser> recievedRequests;
  final List<MyUser> sentRequests;
  const RequestsPage(
      {required this.recievedRequests, required this.sentRequests, super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 15),
            child: Text(
              'Sent Requests',
              textAlign: TextAlign.center,
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
                children: widget.sentRequests
                    .map((user) => ConnectTile(
                          user: user,
                          percent: 0,
                        ))
                    .toList(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              'Recieved requests',
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
                children: widget.recievedRequests
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
