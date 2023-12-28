import 'package:flutter/material.dart';
import '../../services/services.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  SignIn({required this.toggleAuth});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
