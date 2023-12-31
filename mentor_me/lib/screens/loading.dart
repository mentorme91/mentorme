//  This contains the loading screen
// to keep use entertained while information is fetched from database

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
// import 'dart:async';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: const SpinKitWanderingCubes(
        color: Colors.lightBlue,
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int currentIndex = 1;
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          currentIndex = (_controller.value * 2).floor() + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _controller,
              child: (currentIndex == 1)
                  ? Image.asset(
                      'assets/images/Logo1-With_Title.png',
                      width: 200,
                      height: 200,
                    )
                  : Image.asset(
                      'assets/images/Logo2-With_Title.png',
                      width: 200,
                      height: 200,
                    ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
