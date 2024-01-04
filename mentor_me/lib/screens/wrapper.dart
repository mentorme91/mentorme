// This file contains the wrapper which navigates between the
// home screen (when a user is signed in) and
//the authenticate screen (when a user is signed out)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'authentication/authenticate.dart';
import 'Home_screens/Home.dart';
import 'themes.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isDarkMode = false;
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  bool mode() {
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    // get user information to determine whether user is signed in or not (not null or null)
    final user = Provider.of<User?>(context);
    return Theme(
        data: isDarkMode ? darkTheme : lightTheme,
        child: (user == null)
            ? const Auhenticate()
            : Home(
                toggleTheme: toggleTheme,
                user: user,
                mode: mode,
              ));
  }
}
