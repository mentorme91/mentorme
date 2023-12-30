// This file contains the user's Home screen

import 'package:flutter/material.dart';
import '../../services/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          TextButton.icon(
              onPressed: () {
                dynamic res = _auth.SignOut();
                if (res == null) {
                  print("Could not sign out");
                }
              },
              icon: Icon(Icons.logout),
              label: Text('Sign Out'))
        ],
      ),
      body: Text('Hello!'),
    );
  }
}
