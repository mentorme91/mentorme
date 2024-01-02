import 'package:flutter/material.dart';
import 'package:mentor_me/screens/loading.dart';
import '../../services/services.dart';
import '../../services/helper_methods.dart';

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen() //loading screen
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: BackButtonIcon(),
                onPressed: () => widget.toggleAuth(1),
                style: ButtonStyle(
                  elevation: MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 107, 246)),
                ),
              ),
            ),
            body: Container(
              height: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        'Forgot Passowrd',
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
                        'Enter your account email, we will send you a verification code',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '$wrongCredentials',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
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
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 55,
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(255, 56, 107, 246),
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
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
                                      decoration: const InputDecoration(
                                        // iconColor: Colors.blue,
                                        // suffix: Icon(Icons.email),
                                        // suffixIconColor: Colors.black,
                                        border: OutlineInputBorder(
                                            gapPadding: 1,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 0.0,
                                              style: BorderStyle.none,
                                            )),
                                      ),
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
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 56, 107, 246)),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 100)),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState != null) {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(() {
                                  loading = true;
                                });
                                String? res = await _auth.resetPassword(email);
                                if (res != null) {
                                  setState(() {
                                    loading = false;
                                    widget.toggleAuth(1,
                                        message:
                                            'Recovery email sent successfully!');
                                  });
                                } else {
                                  setState(() {
                                    loading = false;
                                    wrongCredentials =
                                        'This email is not in our database';
                                  });
                                }
                              }
                            } else {
                              print(_formkey.currentState?.validate());
                            }
                          },
                          child: Text(
                            'Verify Email',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
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
                        Text(
                          'Don\'t have an account yet?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => widget.toggleAuth(2),
                          child: Text(
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
