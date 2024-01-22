import 'package:flutter/material.dart';
import 'package:mentor_me/theme_provider.dart';
import 'package:provider/provider.dart';
// import 'package:mentor_me/services/services.dart';
// import 'package:provider/provider.dart';

class NotificationsThemeLoader extends StatefulWidget {
  const NotificationsThemeLoader({super.key});

  @override
  State<NotificationsThemeLoader> createState() =>
      _NotificationsThemeLoaderState();
}

class _NotificationsThemeLoaderState extends State<NotificationsThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: Notifications());
  }
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
