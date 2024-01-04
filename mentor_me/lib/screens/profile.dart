import 'package:flutter/material.dart';
import 'package:mentor_me/screens/personal_info.dart';
import 'package:mentor_me/screens/themes.dart';
import '../services/services.dart';
import 'notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  MyUser user;
  final Function toggleTheme;
  final Function mode;
  UserProfile(
      {required this.user,
      required this.toggleTheme,
      required this.mode,
      super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isDarkMode = false;
  int _pageNum = 0;
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void switchPage(int page, MyUser editedUser) {
    setState(() {
      _pageNum = page;
      widget.user = editedUser;
    });
  }

  bool mode() {
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = widget.mode();
    return Theme(
      data: isDarkMode ? darkTheme : lightTheme,
      child: (_pageNum == 0)
          ? Profile(
              toggleTheme: widget.toggleTheme,
              user: widget.user,
              profileToggleTheme: toggleTheme,
              mode: mode,
              switchPage: switchPage,
            )
          : (_pageNum == 1)
              ? PersonalInfo(
                  switchPage: switchPage,
                  user: widget.user,
                )
              : Notifications(
                  switchPage: switchPage,
                  user: widget.user,
                ),
    );
  }
}

class Profile extends StatefulWidget {
  final MyUser user;
  final Function toggleTheme;
  final Function profileToggleTheme;
  final Function mode;
  final Function switchPage;
  const Profile(
      {required this.user,
      required this.toggleTheme,
      required this.profileToggleTheme,
      required this.mode,
      required this.switchPage,
      super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final AuthService _auth = AuthService();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          'Profile',
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
                  TextButton(
                    onPressed: () async {
                      String? imageURL = await captureImage(widget.user);
                      if (imageURL == null) {
                        print('Failed!');
                        return;
                      }
                      setState(() {
                        widget.user.photoURL = imageURL;
                        user?.updatePhotoURL(imageURL);
                      });
                      await DatabaseService(uid: '')
                          .UpdateStudentCollection(widget.user, user);
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          const AssetImage('assets/images/face.png'),
                      foregroundImage: (widget.user.photoURL != null)
                          ? NetworkImage(widget.user.photoURL ?? '')
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    '${widget.user.first_name} ${widget.user.last_name}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${widget.user.email}'),
                ]),
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
                          widget.switchPage(1, widget.user);
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
                          widget.switchPage(2, widget.user);
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Switch to ${widget.mode() ? 'light' : 'dark'} Mode',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              widget.mode()
                                  ? Icons.brightness_6_outlined
                                  : Icons.brightness_6,
                              size: 30.0,
                              color: Theme.of(context).colorScheme.background,
                            ), // Icon for dark mode switch
                            onPressed: () {
                              setState(
                                () {
                                  widget.toggleTheme();
                                  widget.profileToggleTheme();
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
                        _auth.SignOut();
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
            ],
          ),
        ),
      ),
    );
  }
}
