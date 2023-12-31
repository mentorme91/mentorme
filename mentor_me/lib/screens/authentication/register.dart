import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../loading.dart';
import '../../services/helper_methods.dart';
import '../../services/schools_info.dart';

class Register extends StatefulWidget {
  final Function toggleAuth;
  Register({required this.toggleAuth});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  MyUser user = MyUser(
    uid: '',
    email: '',
    first_name: '',
    last_name: '',
    school_id: '',
    faculty: '',
    department: '',
    status: '',
    year: 0,
  );
  bool obscure = false, reobscure = false;
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String retypePassword = '';

  @override
  Widget build(BuildContext context) {
    // Color primaryColor = Theme.of(context).colorScheme.primary;
    // Color secondaryColor = Theme.of(context).colorScheme.secondary;
    return loading
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0),
                style: ButtonStyle(
                  elevation: MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Create Account',
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
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: TextStyle(
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: TextFormField(
                              style: TextStyle(
                                decorationColor: Colors.black,
                              ),
                              autofocus: true,
                              keyboardType: TextInputType.name,
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
                                  user.first_name = value;
                                });
                              },
                              validator: (value) => validateText(
                                  user.first_name, 'Enter first name'),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Last Name',
                            style: TextStyle(
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                decorationColor: Colors.black,
                              ),
                              autofocus: true,
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
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  user.last_name = value;
                                });
                              },
                              validator: (value) => validateText(
                                  user.last_name, 'Enter last name'),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
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
                                      style: TextStyle(
                                          decorationColor: Colors.black),
                                      autofocus: true,
                                      keyboardType: TextInputType.emailAddress,
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
                                          ),
                                        ),
                                      ),
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
                                  icon: Icon(Icons.email),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'School',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: DropdownButtonFormField(
                              validator: (value) =>
                                  validateText(user.school_id, 'Enter school'),
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
                                  ),
                                ),
                              ),
                              items: createDropDown(
                                  produceList(schools_faculties)),
                              onChanged: (val) {
                                setState(() {
                                  user.school_id = val ?? '';
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Faculty',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: DropdownButtonFormField(
                              validator: (value) =>
                                  validateText(user.faculty, 'Enter faculty'),
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
                                  ),
                                ),
                              ),
                              items: createDropDown(
                                  schools_faculties[user.school_id] ?? []),
                              onChanged: (val) {
                                setState(() {
                                  user.faculty = val ?? '';
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Department',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: DropdownButtonFormField(
                              validator: (value) => validateText(
                                  user.department, 'Enter department'),
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
                                  ),
                                ),
                              ),
                              items: createDropDown(
                                  faculties_dept[user.faculty] ?? []),
                              onChanged: (val) {
                                setState(() {
                                  user.department = val ?? '';
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Year in School',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: DropdownButtonFormField(
                              validator: (value) => validateText(
                                  (user.year == 0) ? '' : 'not zero',
                                  'Enter email'),
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
                                  ),
                                ),
                              ),
                              items: createDropDown(['1', '2', '3', '4']),
                              onChanged: (val) {
                                setState(() {
                                  user.year = int.tryParse(val) ?? 1;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Satus (Mentor/Mentee)',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.center,
                            child: DropdownButtonFormField(
                              validator: (value) =>
                                  validateText(user.status, 'Enter status'),
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
                                  ),
                                ),
                              ),
                              items: createDropDown(
                                  ['Mentor', 'Mentee', 'Visitor']),
                              onChanged: (val) {
                                setState(() {
                                  user.year = int.tryParse(val) ?? 0;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
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
                                      style: TextStyle(
                                          decorationColor: Colors.black),
                                      autofocus: true,
                                      obscureText: !obscure,
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
                                          ),
                                        ),
                                      ),
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
                                  icon: Icon(obscure
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Retype password',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
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
                                      style: TextStyle(
                                          decorationColor: Colors.black),
                                      autofocus: true,
                                      obscureText: !reobscure,
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
                                          ),
                                        ),
                                      ),
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
                                  icon: Icon(reobscure
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 40)),
                          ),
                          onPressed: () async {
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
                          },
                          child: Text(
                            'Create An Account',
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.secondary,
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
                        Text('Already have an Account?'),
                        TextButton(
                          onPressed: () => widget.toggleAuth(1),
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
