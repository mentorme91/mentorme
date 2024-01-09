import 'package:flutter/material.dart';
import 'package:mentor_me/screens/profile_screens/profile.dart';
import 'package:mentor_me/screens/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../services/services.dart';

class ConnectProfileThemeLoader extends StatefulWidget {
  final MyUser match;
  const ConnectProfileThemeLoader({super.key, required this.match});

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
          match: widget.match,
        ));
  }
}

class ConnectProfile extends StatefulWidget {
  final MyUser match;
  const ConnectProfile({super.key, required this.match});

  @override
  State<ConnectProfile> createState() => _ConnectProfileState();
}

class _ConnectProfileState extends State<ConnectProfile> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(image: widget.match.photoURL),
                ));
              },
              child: Hero(
                tag: 'userImage',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.match.photoURL ??
                      'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                  radius: 60.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
