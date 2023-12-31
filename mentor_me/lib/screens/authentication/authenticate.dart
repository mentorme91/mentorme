// This file navigate between the different pages in the authentication screen
// 1. The Intro screen (or Squash): First screen the user sees
// 2. The SignIn screen: Where an existing user will sign in
// 3. The Register screen: Where a new user registers

import 'package:flutter/material.dart';

import 'register.dart';
import 'sign_in.dart';
import 'intro.dart';
import 'forgot_password.dart';

class Auhenticate extends StatefulWidget {
  const Auhenticate({super.key});

  @override
  State<Auhenticate> createState() => _AuhenticateState();
}

class _AuhenticateState extends State<Auhenticate> {
  String message = '';
  int pageNum =
      0; // 0 - Intro, 1 - SignIn, 2 - Register, 3 - Forgot Password, 4 - New password

  // used to toggle between pages
  void ToggleAuth(int pageN, {String message = ''}) {
    setState(() {
      pageNum = pageN;
      this.message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _auth_pages = [
      Intro(
        toggleAuth: ToggleAuth,
      ),
      SignIn(
        toggleAuth: ToggleAuth,
        message: message,
      ),
      Register(toggleAuth: ToggleAuth),
      ForgotPassword(toggleAuth: ToggleAuth),
    ];
    return _auth_pages[pageNum];
  }
}
