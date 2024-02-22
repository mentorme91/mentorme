import 'package:flutter/material.dart';
import 'package:mentor_me/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            widget.toggleAuth(1,
                message: AppLocalizations.of(context)!.recoveryEmail);
          });
        } else {
          setState(() {
            loading = false;
            wrongCredentials = AppLocalizations.of(context)!.emailError;
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
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.passwordLink,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
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
                          Text(
                            AppLocalizations.of(context)!.email,
                            style: const TextStyle(
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
                                          email,
                                          AppLocalizations.of(context)!
                                              .invalidEmail),
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
                          child: Text(
                            AppLocalizations.of(context)!.sendEmial,
                            style: const TextStyle(
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
                        Text(
                          AppLocalizations.of(context)!.noAccount,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => widget.toggleAuth(2),
                          child: Text(
                            AppLocalizations.of(context)!.account,
                            style: const TextStyle(
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
