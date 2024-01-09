import 'package:flutter/material.dart';
import 'package:mentor_me/screens/theme_provider.dart';
import 'package:mentor_me/services/helper_methods.dart';
import 'package:mentor_me/services/services.dart';
import 'package:provider/provider.dart';
import '../../../services/schools_info.dart';

class PersonalInfoThemeLoader extends StatefulWidget {
  const PersonalInfoThemeLoader({super.key});

  @override
  State<PersonalInfoThemeLoader> createState() =>
      _PersonalInfoThemeLoaderState();
}

class _PersonalInfoThemeLoaderState extends State<PersonalInfoThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: PersonalInfo());
  }
}

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _formkey = GlobalKey<FormState>();
  Map<String, bool> enablers = {
    'first_name': false,
    'last_name': false,
    'email': false,
    'school': false,
    'faculty': false,
    'department': false,
    'year': false,
    'status': false
  };
  bool loading = false;
  bool obscure = false;
  MyUser dummy = newUser();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if (dummy.toString() == newUser().toString()) {
      dummy.updateUserFromUser(user ?? MyUser());
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: AppBar(),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () => {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            )
                          },
                      icon: const BackButtonIcon()),
                  Expanded(
                    child: FractionallySizedBox(
                      child: Center(
                        child: Text(
                          'Personal Information',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('First Name'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    dummy.updateUserFromUser(dummy);
                                    enablers['first_name'] =
                                        !(enablers['first_name'] ?? false);
                                  },
                                );
                              }
                            },
                            child: Text(enablers['first_name'] ?? false
                                ? 'Save'
                                : 'Edit'),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: dummy.first_name,
                        enabled: enablers['first_name'],
                        onChanged: (value) {
                          dummy.first_name = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Last Name'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    enablers['last_name'] =
                                        !(enablers['last_name'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(enablers['last_name'] ?? false
                                ? 'Save'
                                : 'Edit'),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: dummy.last_name,
                        enabled: enablers['last_name'],
                        onChanged: (value) {
                          dummy.last_name = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Email'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    enablers['email'] =
                                        !(enablers['email'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(
                                enablers['email'] ?? false ? 'Save' : 'Edit'),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: dummy.email,
                        enabled: enablers['email'],
                        onChanged: (value) {
                          dummy.email = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('School'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    // enablers['school'] =
                                    //     !(enablers['school'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(
                                enablers['school'] ?? false ? 'Save' : 'Edit'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        items: (enablers['school'] ?? false)
                            ? createDropDown(produceList(schools_faculties))
                            : null,
                        value: dummy.school_id,
                        onChanged: (value) {
                          dummy.school_id = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                        decoration: InputDecoration(
                          hintText: dummy.school_id,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Faculty'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    enablers['faculty'] =
                                        !(enablers['faculty'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(
                                enablers['faculty'] ?? false ? 'Save' : 'Edit'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        items: (enablers['faculty'] ?? false)
                            ? createDropDown(
                                schools_faculties[dummy.school_id] ?? [])
                            : null,
                        value: dummy.faculty,
                        onChanged: (value) {
                          dummy.faculty = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                        decoration: InputDecoration(
                          hintText: dummy.faculty,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Department'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    enablers['department'] =
                                        !(enablers['department'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(enablers['department'] ?? false
                                ? 'Save'
                                : 'Edit'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        items: (enablers['department'] ?? false)
                            ? createDropDown(
                                faculties_dept[dummy.faculty] ?? [])
                            : null,
                        value: dummy.department,
                        onChanged: (value) {
                          dummy.department = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                        decoration: InputDecoration(
                          hintText: dummy.department,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    enablers['status'] =
                                        !(enablers['status'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(
                                enablers['status'] ?? false ? 'Save' : 'Edit'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        items: (enablers['status'] ?? false)
                            ? createDropDown(['Mentor', 'Mentee', 'Visitor'])
                            : null,
                        value: dummy.status,
                        onChanged: (value) {
                          dummy.status = value;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                        decoration: InputDecoration(
                          hintText: dummy.status,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Year'),
                          TextButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                setState(
                                  () {
                                    enablers['year'] =
                                        !(enablers['year'] ?? false);
                                    dummy.updateUserFromUser(dummy);
                                  },
                                );
                              }
                            },
                            child: Text(
                                enablers['year'] ?? false ? 'Save' : 'Edit'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        items: (enablers['year'] ?? false)
                            ? createDropDown(['1', '2', '3', '4'])
                            : null,
                        value: dummy.year.toString(),
                        onChanged: (value) {
                          dummy.year = int.tryParse(value) ?? 1;
                        },
                        validator: (value) =>
                            validateText(value, 'Incorrect value'),
                        decoration: InputDecoration(
                          hintText: dummy.year.toString(),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Password'),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Change Password'),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                      //   child: Divider(
                      //     color: Theme.of(context)
                      //         .colorScheme
                      //         .onPrimary, // Set the color to white
                      //     height: 1, // Set the height of the divider
                      //   ),
                      // ),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).primaryColor),
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 50)),
                    ),
                    onPressed: () async {
                      if (_formkey.currentState != null) {
                        if ((_formkey.currentState?.validate() ?? false) &&
                            (enablers.values
                                .every((value) => value == false))) {
                          user?.updateUserFromUser(dummy);
                          setState(() {
                            loading = true;
                            user?.updateUserFromUser(dummy);
                          });
                          await DatabaseService(uid: '')
                              .UpdateStudentCollection(user);
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    child: Text(
                      loading ? 'Loading...' : 'Save changes',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.background),
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 40)),
                      side: MaterialStatePropertyAll<BorderSide>(
                        BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _formkey.currentState?.reset();
                      setState(() {
                        dummy.updateUserFromUser(user ?? MyUser());
                      });
                    },
                    child: Text(
                      'Cancel changes',
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
        ),
      ),
    );
  }
}
