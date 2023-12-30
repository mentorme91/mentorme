// This file navigate between the different pages in the authentication screen
// 1. The Intro screen (or Squash): First screen the user sees
// 2. The SignIn screen: Where an existing user will sign in
// 3. The Register screen: Where a new user registers

import 'package:flutter/material.dart';

import 'register.dart';
import 'sign_in.dart';
import 'intro.dart';

class Auhenticate extends StatefulWidget {
  const Auhenticate({super.key});

  @override
  State<Auhenticate> createState() => _AuhenticateState();
}

class _AuhenticateState extends State<Auhenticate> {
  int pageNum = 0; // 0 - Intro, 1 - SignIn, 2 - Register

  // used to toggle between pages
  void ToggleAuth(int pageN) {
    setState(() {
      pageNum = pageN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (pageNum == 0)
        ? Intro(toggleAuth: ToggleAuth)
        : ((pageNum == 1)
            ? SignIn(toggleAuth: ToggleAuth)
            : Register(toggleAuth: ToggleAuth));
  }
}
