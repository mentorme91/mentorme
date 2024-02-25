import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/input_verification.dart';
import '../../../../themes.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  String password = '', retypePassword = '', oldPassword = '', error = '';
  final double formheight = 60;
  double radius = 25;
  bool obscure = false, reobscure = false, loading = false;
  final _formkey = GlobalKey<FormState>();
  int attempts = 0;

  Future<bool> resetPassword() async {
    final user = FirebaseAuth.instance.currentUser;

    final credential = EmailAuthProvider.credential(
        email: user?.email ?? '', password: oldPassword);
    try {
      await user?.reauthenticateWithCredential(credential);
      // proceed with password change
      setState(() {
        user?.updatePassword(password);
      });
      return true;
    } on FirebaseAuthException catch (e) {
      // handle if reauthenticatation was not successful
      print(e.toString());
      setState(() {
        if (attempts > 5) {
          error = AppLocalizations.of(context)!.attempts;
        } else {
          error = AppLocalizations.of(context)!.invalidPass;
        }
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: Column(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.oldPass,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: formheight,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    decoration: boxDecoration(Theme.of(context), radius),
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: FractionallySizedBox(
                            child: TextFormField(
                              style: const TextStyle(),
                              obscureText: !obscure,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: inputDecoration(
                                  Theme.of(context), radius, null),
                              onChanged: (value) {
                                setState(() {
                                  oldPassword = value;
                                });
                              },
                              validator: (value) =>
                                  validatePassword(oldPassword),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.newPass,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: formheight,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    decoration: boxDecoration(Theme.of(context), radius),
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: FractionallySizedBox(
                            child: TextFormField(
                              style: const TextStyle(),
                              obscureText: !reobscure,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: inputDecoration(
                                  Theme.of(context), radius, null),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              validator: (value) => validatePassword(password),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(
                              () {
                                reobscure = !reobscure;
                              },
                            )
                          },
                          icon: Icon(
                            reobscure
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.retypeNewPass,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: formheight,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    decoration: boxDecoration(Theme.of(context), radius),
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: FractionallySizedBox(
                            child: TextFormField(
                              style: const TextStyle(),
                              obscureText: !reobscure,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: inputDecoration(
                                  Theme.of(context), radius, null),
                              onChanged: (value) {
                                setState(() {
                                  retypePassword = value;
                                });
                              },
                              validator: (value) => (retypePassword == password)
                                  ? null
                                  : AppLocalizations.of(context)!
                                      .incorrectPassword,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(
                              () {
                                reobscure = !reobscure;
                              },
                            )
                          },
                          icon: Icon(
                            reobscure
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).primaryColor),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 30)),
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  if (_formkey.currentState != null) {
                    if (_formkey.currentState?.validate() ?? false) {
                      bool isReset = await resetPassword();
                      if (isReset) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                AppLocalizations.of(context)!.passUpdated,
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }
                  setState(() {
                    loading = false;
                  });
                },
                child: Text(
                  loading
                      ? AppLocalizations.of(context)!.load
                      : AppLocalizations.of(context)!.reset,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.background),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 30)),
                  side: MaterialStatePropertyAll<BorderSide>(
                    BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
