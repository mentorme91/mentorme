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
  int isSignIn = 0;
  void ToggleAuth(int page_num) {
    setState(() {
      isSignIn = page_num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isSignIn == 0)
        ? Intro(toggleAuth: ToggleAuth)
        : ((isSignIn == 1)
            ? SignIn(toggleAuth: ToggleAuth)
            : Register(toggleAuth: ToggleAuth));
  }
}
