import 'package:flutter/material.dart';
import 'package:mentor_me/screens/authentication/register/user_school_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/user.dart';
import '../../../services/input_verification.dart';
import '../../../themes.dart';

class UserInfo extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;
  const UserInfo(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final double _formheight = 60;
  final _formkey = GlobalKey<FormState>();
  double radius = 25;

  void _goToNextPage() {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserSchoolInfoThemeLoader(
                  toggleAuth: widget.toggleAuth, user: widget.user),
            ),
          );
        });
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () => widget.toggleAuth(0, back: true),
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(200),
            iconColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 56, 107, 246)),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    Text(
                      AppLocalizations.of(context)!.firstName,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                      child: TextFormField(
                        style: const TextStyle(),
                        keyboardType: TextInputType.name,
                        decoration:
                            inputDecoration(Theme.of(context), radius, null),
                        onChanged: (value) {
                          setState(() {
                            widget.user.first_name = value;
                          });
                        },
                        validator: (value) => validateText(
                            widget.user.first_name,
                            AppLocalizations.of(context)!.firstNameGuide),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      AppLocalizations.of(context)!.lastName,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        style: const TextStyle(),
                        decoration:
                            inputDecoration(Theme.of(context), radius, null),
                        onChanged: (value) {
                          setState(() {
                            widget.user.last_name = value;
                          });
                        },
                        validator: (value) => validateText(
                            widget.user.last_name,
                            AppLocalizations.of(context)!.lastNameNote),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: inputDecoration(
                                    Theme.of(context), radius, null),
                                onChanged: (value) {
                                  setState(() {
                                    widget.user.email = value;
                                  });
                                },
                                validator: (value) => validateText(
                                    widget.user.email,
                                    AppLocalizations.of(context)!.emailGuide),
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
                      height: 20,
                    ),
                  ],
                ),
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
                    onPressed: _goToNextPage,
                    child: Text(
                      AppLocalizations.of(context)!.next,
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
            ],
          ),
        ),
      ),
    );
  }
}
