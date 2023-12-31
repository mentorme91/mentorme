// This file contains the user's Home screen

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../../services/services.dart';
// import '../../services/helper_methods.dart';
// import 'package:provider/provider.dart';
import 'home_page.dart';
import 'connections_page.dart';
import 'resources_page.dart';
import 'opportunities_page.dart';
// import '../loading.dart';

class Home extends StatefulWidget {
  final User? user;
  const Home({this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double radius = 50;
  int _pageIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    ConnectionsPage(),
    ResourcesPage(),
    OpportunitiesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(),
      ),
      body: SingleChildScrollView(
        child: _pages[_pageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.primary,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              // color: Colors.black,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups_rounded,
              // color: Colors.white,
              size: 30,
            ),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.layers_rounded,
              // color: Colors.black,
              size: 30,
            ),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              // color: Colors.white,
              size: 30,
            ),
            label: 'Opportunities',
          ),
        ],
      ),
    );
  }
}
