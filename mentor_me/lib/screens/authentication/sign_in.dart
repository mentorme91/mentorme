import 'package:flutter/material.dart';
import 'package:mentor_me/screens/loading.dart';
import '../../services/services.dart';
import '../../services/helper_methods.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  String message;
  SignIn({required this.toggleAuth, this.message = ''});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth =
      AuthService(); // auth service used to sign in to firebase
  String email = '', password = '';
  final _formkey = GlobalKey<FormState>(); // used to validate inputs
  bool loading = false; // used to display loading screen
  String wrongCredentials = ''; // display error of wrong credentials
  bool obscure = false;

  @override
  Widget build(BuildContext context) {
    wrongCredentials = widget.message;
    return loading
        ? LoadingScreen() //loading screen
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0),
                style: ButtonStyle(
                  elevation: MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 107, 246)),
                ),
              ),
            ),
            body: Container(
              color: Colors.white,
              height: double.infinity,
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
                        'Log In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
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
                            height: 60,
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
                                      validator: (value) =>
                                          validateText(email, 'Enter email'),
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
                          Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 60,
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
                                      obscureText: !obscure,
                                      cursorColor: Colors.black,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        decorationColor: Colors.black,
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: const InputDecoration(
                                        // iconColor: Colors.blue,
                                        // suffix: Icon(Icons.remove_red_eye),
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
                                    color: Colors.black,
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
                                  child: Text(
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
                    SizedBox(
                      height: 40,
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
                                dynamic auth_user =
                                    await _auth.SignInUser(email, password);
                                if (auth_user == null) {
                                  setState(() {
                                    loading = false;
                                  });
                                  widget.message = 'Incorrect credentials';
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
