import 'package:flutter/material.dart';
import 'package:mentor_me/screens/loading.dart';
import '../../services/services.dart';
import '../../services/helper_methods.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  SignIn({required this.toggleAuth});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String email = '', password = '';
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String wrongCredentials = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0),
                style: ButtonStyle(
                  elevation: MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        'Log In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        '$wrongCredentials',
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            style: TextStyle(decorationColor: Colors.black),
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              // iconColor: Colors.blue,
                              suffix: Icon(Icons.email),
                              suffixIconColor: Colors.black,
                              border: OutlineInputBorder(
                                  gapPadding: 1,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.2,
                                  )),
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (value) =>
                                validateText(email, 'Enter email'),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(decorationColor: Colors.black),
                            autofocus: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              // iconColor: Colors.blue,
                              suffix: Icon(Icons.remove_red_eye),
                              suffixIconColor: Colors.black,
                              border: OutlineInputBorder(
                                  gapPadding: 1,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.2,
                                  )),
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            validator: (value) => validatePassword(password),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 100)),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState != null) {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic auth_user =
                                    await _auth.SignInUser(email, password);
                                if (auth_user == null) {
                                  setState(() {
                                    loading = false;
                                  });
                                  wrongCredentials = 'Incorrect credentials';
                                  print('Failed to sign in');
                                } else {
                                  print('Success');
                                }
                              }
                            } else {
                              print(_formkey.currentState?.validate());
                            }
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account yet?'),
                        TextButton(
                          onPressed: () => widget.toggleAuth(2),
                          child: Text('Create Account'),
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
