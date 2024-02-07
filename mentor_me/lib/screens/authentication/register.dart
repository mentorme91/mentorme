import 'package:flutter/material.dart';
import 'package:mentor_me/screens/authentication/register/user_info.dart';

import '../../models/user.dart';

class Register extends StatefulWidget {
  final Function toggleAuth;
  Register({required this.toggleAuth});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  MyUser user = MyUser();

  @override
  Widget build(BuildContext context) {
    return UserInfo(toggleAuth: widget.toggleAuth, user: user);
  }
}
