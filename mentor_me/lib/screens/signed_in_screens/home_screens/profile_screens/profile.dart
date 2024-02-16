import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/user.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/database_service.dart';
import '../../../../services/storage_service.dart';
import '../../../../theme_provider.dart';
import 'calendar.dart';
import 'detailed_image.dart';
import 'notifications.dart';
import 'personal_info.dart';
import 'time_planner.dart';
import 'Language.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: Profile(),
    );
  }
}

TextEditingController _Controller = TextEditingController();

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _pushAboutEditor(MyUser? user) async {
    await showDialog(
        context: context,
        builder: ((context) {
          String about = user?.about ?? '';
          DatabaseService _database = DatabaseService(uid: user?.uid);
          return AlertDialog(
            title: Text(
              'Add About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: TextFormField(
              initialValue: about,
              onChanged: (value) => about = value,
              maxLength: 150,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                  )),
              TextButton(
                  onPressed: () {
                    user?.about = about;
                    _database.UpdateStudentCollection(user);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                  )),
            ],
          );
        }));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 50,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 3), // changes the position of the shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 0.2,
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              image: user?.photoURL,
                              uid: user?.uid,
                            ),
                          ));
                        },
                        child: Hero(
                          tag: 'userImage${user?.uid}',
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user?.photoURL ??
                                'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ'),
                            radius: 60.0,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          String? imageURL = await StorageService()
                              .captureImage(user ?? MyUser());
                          if (imageURL == null) {
                            print('Failed!');
                            return;
                          }
                          setState(() {
                            user?.photoURL = imageURL;
                          });
                          await DatabaseService(uid: '')
                              .UpdateStudentCollection(user);
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image_search,
                            color: Colors.white,
                          ), // Change the color as needed
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    '${user?.first_name} ${user?.last_name}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${user?.email}'),
                ]),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 50,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 3), // changes the position of the shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 0.2,
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  children: [
                    Text(
                      'About',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(user?.about ?? ''),
                          ),
                          IconButton(
                            onPressed: () => _pushAboutEditor(user),
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 30,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 3), // changes the position of the shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 0.2,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      PersonalInfoThemeLoader())));
                        });
                      },
                      leading: const Icon(
                        Icons.person_2,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Personal Info',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white, // Set the color to white
                        height: 1, // Set the height of the divider
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) =>
                                  NotificationsThemeLoader())));
                        });
                      },
                      leading: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white, // Set the color to white
                        height: 1, // Set the height of the divider
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      UserCalendarThemeLoader(
                                        user: user ?? MyUser(),
                                      ))));
                        });
                      },
                      leading: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'My Calendar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white, // Set the color to white
                        height: 1, // Set the height of the divider
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      CoursePlannerThemeLoader(
                                        user: user ?? MyUser(),
                                      ))));
                        });
                      },
                      leading: const Icon(
                        Icons.schedule,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'My Schedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white, // Set the color to white
                        height: 1, // Set the height of the divider
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                RadioListTile(
                                  title: const Text('English'),
                                  value: "English",
                                  groupValue: Lang,
                                  onChanged: (value) {
                                    setState(() {
                                      Lang = value.toString();
                                    });
                                  },
                                ),
                                const Divider(
                                  color: Colors.black,
                                  height: 1,
                                ),
                                RadioListTile(
                                    title: const Text('French'),
                                    value: "French",
                                    groupValue: Lang,
                                    onChanged: (value) {
                                      setState(() {
                                        Lang = value.toString();
                                      });
                                    })
                              ],
                            );
                          },
                        );
                      },
                      leading: const Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      title: const Text(
                        "Language",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Switch to ${Provider.of<MyThemeProvider>(context).isDarkMode ? 'light' : 'dark'} Mode',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Provider.of<MyThemeProvider>(context).isDarkMode
                                  ? Icons.brightness_6_outlined
                                  : Icons.brightness_6,
                              size: 30.0,
                              color: Theme.of(context).colorScheme.background,
                            ), // Icon for dark mode switch
                            onPressed: () {
                              setState(
                                () {
                                  Provider.of<MyThemeProvider>(context,
                                          listen: false)
                                      .switchMode();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white, // Set the color to white
                        height: 1, // Set the height of the divider
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _auth.signOut();
                      },
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
