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
  void ToggleAuth(int pageN, {bool back = false, String message = ''}) {
    if (back) {
      stack.removeAt(stack.length - 1);
    } else {
      stack.add(pageN);
    }
    setState(() {
      pageNum = stack.last;
      this.message = message;
    });
  }

  List<int> stack = [4];

  @override
  Widget build(BuildContext context) {
    final List<Widget> authPages = [
      Intro(
        toggleAuth: ToggleAuth,
      ),
      SignIn(
        toggleAuth: ToggleAuth,
        message: message,
      ),
      Register(
        toggleAuth: ToggleAuth,
      ),
      ForgotPassword(
        toggleAuth: ToggleAuth,
      ),
      Onboarding(
        toggleAuth: ToggleAuth,
      )
    ];
    return authPages[pageNum];
  }
}
