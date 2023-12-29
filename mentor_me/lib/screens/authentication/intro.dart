import 'package:flutter/material.dart';
import '../../services/services.dart';

class Intro extends StatefulWidget {
  final Function toggleAuth;
  Intro({required this.toggleAuth});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('MentorMe'),
      ),
      body: Column(
        children: [
          Image(image: AssetImage('assets/images/logo.png')),
          Text('MentorMe'),
          Text('MentorMe'),
          TextButton(
            onPressed: () => widget.toggleAuth(1),
            child: Text('Sign In'),
          ),
          TextButton(
            onPressed: () => widget.toggleAuth(2),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
