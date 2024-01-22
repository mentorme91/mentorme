import 'package:flutter/material.dart';
import 'package:mentor_me/themes.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/input_verification.dart';
import '../../services/json_decoder.dart';
import '../drop_down.dart';
import '../loading.dart';

class Register extends StatefulWidget {
  final Function toggleAuth;
  Register({required this.toggleAuth});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Map<String, dynamic> schoolsData = {}; // Your User class

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the page is initialized
  }

  final AuthService _auth = AuthService();
  MyUser user = newUser();
  final double _formheight = 60;
  bool obscure = false, reobscure = false;
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String retypePassword = '';
  double radius = 25;

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

  void _createAccount() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });
        dynamic auth_user = await _auth.Register(user);
        if (auth_user == null) {
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

  @override
  Widget build(BuildContext context) {
    // Color primaryColor = Theme.of(context).colorScheme.primary;S
    // Color secondaryColor = Theme.of(context).colorScheme.secondary;
    return (loading)
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0, back: true),
                style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 107, 246)),
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
                    const Center(
                      child: Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                          const Text(
                            'First Name',
                            style: TextStyle(
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
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: TextFormField(
                              style: const TextStyle(),
                              keyboardType: TextInputType.name,
                              decoration: inputDecoration(
                                  Theme.of(context), radius, null),
                              onChanged: (value) {
                                setState(() {
                                  user.first_name = value;
                                });
                              },
                              validator: (value) => validateText(
                                  user.first_name, 'Enter first name'),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Last Name',
                            style: TextStyle(
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
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              style: const TextStyle(),
                              decoration: inputDecoration(
                                  Theme.of(context), radius, null),
                              onChanged: (value) {
                                setState(() {
                                  user.last_name = value;
                                });
                              },
                              validator: (value) => validateText(
                                  user.last_name, 'Enter last name'),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
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
                            height: _formheight,
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
                                      style: const TextStyle(),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          user.email = value;
                                        });
                                      },
                                      validator: (value) => validateText(
                                          user.email, 'Enter email'),
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
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            validator: (value) =>
                                validateText(user.school_id, 'Enter school'),
                            decoration: inputDropDownDecoration(
                                Theme.of(context), radius, null),
                            items: createDropDown(schoolsData.keys.toList()),
                            onChanged: (val) {
                              setState(() {
                                user.school_id = val ?? '';
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
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            validator: (value) =>
                                validateText(user.faculty, 'Enter faculty'),
                            decoration: inputDropDownDecoration(
                                Theme.of(context), radius, null),
                            items: createDropDown(
                                schoolsData[user.school_id]?.keys.toList() ??
                                    []),
                            onChanged: (val) {
                              setState(() {
                                user.faculty = val ?? '';
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
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            validator: (value) => validateText(
                                user.department, 'Enter department'),
                            decoration: inputDropDownDecoration(
                                Theme.of(context), radius, null),
                            items: createDropDown(schoolsData[user.school_id]
                                        ?[user.faculty]
                                    ?.keys
                                    .toList() ??
                                []),
                            onChanged: (val) {
                              setState(() {
                                user.department = val ?? '';
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
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            validator: (value) => validateText(
                                (user.year == 0) ? '' : 'not zero',
                                'Enter school year'),
                            decoration: inputDropDownDecoration(
                                Theme.of(context), radius, null),
                            items: createDropDown(['1', '2', '3', '4']),
                            onChanged: (val) {
                              setState(() {
                                user.year = int.tryParse(val) ?? 1;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Satus (Mentor/Mentee)',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          DropdownButtonFormField(
                            dropdownColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            style: TextStyle(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            validator: (value) =>
                                validateText(user.status, 'Enter status'),
                            decoration: inputDropDownDecoration(
                                Theme.of(context), radius, null),
                            items: createDropDown(
                                ['Mentor', 'Mentee', 'Visitor', 'Both']),
                            onChanged: (val) {
                              setState(() {
                                user.status = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
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
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    child: TextFormField(
                                      style: const TextStyle(),
                                      obscureText: !obscure,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          user.SetPassword(value);
                                        });
                                      },
                                      validator: (value) =>
                                          validatePassword(user.GetPassword()),
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
                          const Text(
                            'Retype password',
                            style: TextStyle(
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
                            decoration:
                                boxDecoration(Theme.of(context), radius),
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: FractionallySizedBox(
                                    child: TextFormField(
                                      style: const TextStyle(),
                                      obscureText: !reobscure,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: inputDecoration(
                                          Theme.of(context), radius, null),
                                      onChanged: (value) {
                                        setState(() {
                                          retypePassword = value;
                                        });
                                      },
                                      validator: (value) =>
                                          (retypePassword == user.GetPassword())
                                              ? null
                                              : 'Password does not match',
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
                            'Create An Account',
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
