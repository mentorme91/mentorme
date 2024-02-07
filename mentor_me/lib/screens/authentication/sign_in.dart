import 'package:flutter/material.dart';
import 'package:mentor_me/themes.dart';

import '../../services/auth_service.dart';
import '../../services/input_verification.dart';
import '../loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  const SignIn({required this.toggleAuth, this.message = '', super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth =
      AuthService(); // auth service used to sign in to firebase
  String email = '', password = '';
  final _formkey = GlobalKey<FormState>(); // used to validate inputs
  bool loading = false; // used to display loading screen
  String? wrongCredentials; // display error of wrong credentials
  bool obscure = false;
  double radius = 25;

  void _signIn() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });
        dynamic authUser = await _auth.signInUser(email, password);
        if (authUser == null) {
          setState(() {
            loading = false;
          });
          setState(() {
            wrongCredentials = 'Incorrect credentials';
          });
          print('Failed to sign in');
        } else {
          print('Success');
        }
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  @override
  Widget build(BuildContext context) {
    wrongCredentials ??= widget.message;
    return loading
        ? LoadingScreen() //loading screen
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).colorScheme.background,
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0, back: true),
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
                        'Log In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
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
                            height: 60,
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
                                      autofocus: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          email = value;
                                        });
                                      },
                                      validator: (value) =>
                                          validateText(email, 'Enter email'),
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
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 60,
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
                                      obscureText: !obscure,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },
                                      validator: (value) =>
                                          validatePassword(password),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {
                                    setState(
                                      () {
                                        obscure = !obscure;
                                      },
                                    )
                                  },
                                  icon: Icon(
                                    obscure
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => widget.toggleAuth(3),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 56, 107, 246),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 56, 107, 246)),
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 100)),
                          ),
                          onPressed: _signIn,
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
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
                        ),
                        TextButton(
                          onPressed: () => widget.toggleAuth(2),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                                color: Color.fromARGB(255, 56, 107, 246)),
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
