//  This contains the loading screen
// to keep use entertained while information is fetched from database

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

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
