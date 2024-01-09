import 'package:flutter/material.dart';
import 'package:mentor_me/screens/theme_provider.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: AppBar(),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () => {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            )
                          },
                      icon: const BackButtonIcon()),
                  Expanded(
                    child: FractionallySizedBox(
                      child: Center(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
