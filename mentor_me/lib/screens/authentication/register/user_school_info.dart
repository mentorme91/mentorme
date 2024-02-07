import 'package:flutter/material.dart';
import 'package:mentor_me/screens/authentication/register/extra_info.dart';
import 'package:provider/provider.dart';

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
              const Center(
                child: Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                    const Text(
                      'School',
                      style: TextStyle(
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
                      validator: (value) =>
                          validateText(widget.user.school_id, 'Enter school'),
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
                    const Text(
                      'Faculty',
                      style: TextStyle(
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
                      validator: (value) =>
                          validateText(widget.user.faculty, 'Enter faculty'),
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
                    const Text(
                      'Department',
                      style: TextStyle(
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
                          widget.user.department, 'Enter department'),
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
                    const Text(
                      'Year in School',
                      style: TextStyle(
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
                          'Enter school year'),
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
              SizedBox(
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
                      'Next',
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
                    'Already have an Account?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () => widget.toggleAuth(1),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
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
