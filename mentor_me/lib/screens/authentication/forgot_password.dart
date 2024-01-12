import 'package:flutter/material.dart';
import 'package:mentor_me/screens/themes.dart';

import '../../services/auth_service.dart';
import '../../services/input_verification.dart';
import '../loading.dart';

class ForgotPassword extends StatefulWidget {
  final Function toggleAuth;
  ForgotPassword({required this.toggleAuth});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth =
      AuthService(); // auth service used to sign in to firebase
  String email = '', password = '';
  final _formkey = GlobalKey<FormState>(); // used to validate inputs
  bool loading = false; // used to display loading screen
  String wrongCredentials = ''; // display error of wrong credentials
  bool obscure = false;
  double radius = 25;
  void _sendResetPasswordEmail() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });
        String? res = await _auth.resetPassword(email);
        if (res != null) {
          setState(() {
            loading = false;
            widget.toggleAuth(1, message: 'Recovery email sent successfully!');
          });
        } else {
          setState(() {
            loading = false;
            wrongCredentials = 'This email is not in our database';
          });
        }
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen() //loading screen
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => widget.toggleAuth(1, back: true),
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 107, 246)),
                ),
              ),
            ),
            body: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Center(
                      child: Text(
                        'Forgot Passowrd',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Center(
                      child: Text(
                        'Enter your account email, we will send you a link to change your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '$wrongCredentials',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 55,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        decorationColor: Colors.black,
                                      ),
                                      autofocus: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          email = value;
                                        });
                                      },
                                      validator: (value) => validateText(
                                          email, 'Enter a valid email'),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(
                                    Icons.email,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 56, 107, 246)),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 100)),
                          ),
                          onPressed: _sendResetPasswordEmail,
                          child: const Text(
                            'Send Email',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account yet?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => widget.toggleAuth(2),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Color.fromARGB(255, 56, 107, 246),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
