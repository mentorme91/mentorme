import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/input_verification.dart';
import '../../../theme_provider.dart';
import '../../../themes.dart';
import '../../drop_down.dart';
import '../../loading.dart';

class ExtraInfoThemeLoader extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;

  const ExtraInfoThemeLoader(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<ExtraInfoThemeLoader> createState() => ExtraInfoThemeLoaderState();
}

class ExtraInfoThemeLoaderState extends State<ExtraInfoThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
        data: theme,
        child: ExtraInfo(toggleAuth: widget.toggleAuth, user: widget.user));
  }
}

class ExtraInfo extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;

  const ExtraInfo(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<ExtraInfo> createState() => _ExtraInfoState();
}

class _ExtraInfoState extends State<ExtraInfo> {
  void _createAccount() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });
        dynamic authUser = await _auth.register(widget.user);
        if (authUser == null) {
          setState(() {
            loading = false;
          });
          print('Failed to register');
        } else {
          print('Success');
        }
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  bool loading = false;
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  double radius = 25;
  final double _formheight = 60;
  bool obscure = false, reobscure = false;
  String retypePassword = '';

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(),
            body: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.account,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.status,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonFormField(
                          dropdownColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          style: TextStyle(
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          validator: (value) => validateText(widget.user.status,
                              AppLocalizations.of(context)!.statusValue),
                          decoration: inputDropDownDecoration(
                              Theme.of(context), radius, null),
                          items: createDropDown([
                            AppLocalizations.of(context)!.mentor,
                            AppLocalizations.of(context)!.mentee,
                            AppLocalizations.of(context)!.visitor,
                            AppLocalizations.of(context)!.both,
                          ]),
                          onChanged: (val) {
                            setState(() {
                              widget.user.status = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.password,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          height: _formheight,
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
                                        widget.user.setPassword(value);
                                      });
                                    },
                                    validator: (value) => validatePassword(
                                        widget.user.getPassword()),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.passwordErrorMes,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          height: _formheight,
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
                                    validator: (value) => (retypePassword ==
                                            widget.user.getPassword())
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(255, 56, 107, 246)),
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 40)),
                        ),
                        onPressed: _createAccount,
                        child: Text(
                          AppLocalizations.of(context)!.newAccount,
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
                        AppLocalizations.of(context)!.havingAccount,
                        style: const TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () => widget.toggleAuth(1),
                        child: Text(
                          AppLocalizations.of(context)!.signIn,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 56, 107, 246),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ]))),
          );
  }
}
