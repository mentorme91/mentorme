import 'package:flutter/material.dart';
import 'package:mentor_me/screens/authentication/register/extra_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/user.dart';
import '../../../services/input_verification.dart';
import '../../../services/json_decoder.dart';
import '../../../theme_provider.dart';
import '../../../themes.dart';
import '../../drop_down.dart';

class UserSchoolInfoThemeLoader extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;

  const UserSchoolInfoThemeLoader(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<UserSchoolInfoThemeLoader> createState() =>
      UserSchoolInfoThemeLoaderState();
}

class UserSchoolInfoThemeLoaderState extends State<UserSchoolInfoThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
        data: theme,
        child:
            UserSchoolInfo(toggleAuth: widget.toggleAuth, user: widget.user));
  }
}

class UserSchoolInfo extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;

  const UserSchoolInfo(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<UserSchoolInfo> createState() => _UserSchoolInfoState();
}

class _UserSchoolInfoState extends State<UserSchoolInfo> {
  Map<String, dynamic> schoolsData = {}; // Your User class

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the page is initialized
  }

  void _goToNextPage() {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExtraInfoThemeLoader(
                  toggleAuth: widget.toggleAuth, user: widget.user),
            ),
          );
        });
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> jsonMap = await loadJsonData('schools_info.json');
      setState(() {
        schoolsData = jsonMap;
      });
    } catch (error) {
      // Handle errors
      print('Error fetching data: $error');
    }
  }

  final _formkey = GlobalKey<FormState>();
  double radius = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
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
                      AppLocalizations.of(context)!.school,
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
                      validator: (value) => validateText(widget.user.school_id,
                          AppLocalizations.of(context)!.schoolGuide),
                      decoration: inputDropDownDecoration(
                          Theme.of(context), radius, null),
                      items: createDropDown(schoolsData.keys.toList()),
                      onChanged: (val) {
                        setState(() {
                          widget.user.school_id = val ?? '';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.faculty,
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
                      validator: (value) => validateText(widget.user.faculty,
                          AppLocalizations.of(context)!.facultyGuide),
                      decoration: inputDropDownDecoration(
                          Theme.of(context), radius, null),
                      items: createDropDown(
                          schoolsData[widget.user.school_id]?.keys.toList() ??
                              []),
                      onChanged: (val) {
                        setState(() {
                          widget.user.faculty = val ?? '';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.department,
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
                      validator: (value) => validateText(widget.user.department,
                          AppLocalizations.of(context)!.departmentGuide),
                      decoration: inputDropDownDecoration(
                          Theme.of(context), radius, null),
                      items: createDropDown(schoolsData[widget.user.school_id]
                                  ?[widget.user.faculty]
                              ?.keys
                              .toList() ??
                          []),
                      onChanged: (val) {
                        setState(() {
                          widget.user.department = val ?? '';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.yearNote,
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
                      validator: (value) => validateText(
                          (widget.user.year == null) ? '' : 'not zero',
                          AppLocalizations.of(context)!.yearGuide),
                      decoration: inputDropDownDecoration(
                          Theme.of(context), radius, null),
                      items: createDropDown(['1', '2', '3', '4']),
                      onChanged: (val) {
                        setState(() {
                          widget.user.year = int.tryParse(val) ?? 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
