// This file contains the wrapper which navigates between the
// home screen (when a user is signed in) and
//the authenticate screen (when a user is signed out)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../notifications_provider.dart';
import 'authentication/authenticate.dart';
import 'signed_in_screens/Home.dart';
import '../theme_provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    /// get user information to determine whether user is signed in or not (not null or null)
    final MyUser? user = Provider.of<MyUser?>(context);
    return Theme(
      data: Provider.of<MyThemeProvider>(context).theme,
      child: (user == null)
          ? const Auhenticate()
          : ChangeNotifierProvider(
              create: (_) => NotificationProvider(user: user),
              child: Home(),
            ),
    );
  }
}
