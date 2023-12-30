import 'package:flutter/material.dart';
// import '../../services/services.dart';

// the introduction page or Squash (First page the user sees)
class Intro extends StatefulWidget {
  final Function
      toggleAuth; // allows toggle between the intro, register and signIn pages
  Intro({required this.toggleAuth});

  @override
  State<Intro> createState() => _IntroState();
}

// Intro state class
class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            // used to toggle to the signIn page
            onPressed: () => widget.toggleAuth(1),
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        // allows user to scroll down and up on the page
        child: Column(
          children: [
            SizedBox(
              // just for space
              height: 5,
            ),
            Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Enhance Learning and Knowledge Sharing',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'MentorMe aims at lorem ipsum dolor sit amet consectetur. Diam integer felis etiam neque id viv.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.primary),
                padding: MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 40)),
              ),
              onPressed: () => widget.toggleAuth(2),
              child: Text(
                'Create An Account',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.secondary),
                padding: MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 80)),
                side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.primary)),
              ),
              onPressed: () => widget.toggleAuth(1),
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
