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

class Home extends StatefulWidget {
  final User? user;
  final Function toggleTheme;
  const Home({required this.toggleTheme, this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double radius = 50;
  int _pageIndex = 0;
  final List<Widget> _pages = const [
    ConnectionsPage(),
    ConnectionsPage(),
    ResourcesPage(),
    OpportunitiesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(),
      ),
      body: SingleChildScrollView(
        child: (_pageIndex != 0)
            ? _pages[_pageIndex]
            : HomePage(toggleTheme: widget.toggleTheme),
      ),
      floatingActionButton: (_pageIndex == 1)
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => widget.toggleTheme(),
              child: Icon(
                Icons.messenger,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
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
              Icons.home_rounded,
              // color: Colors.black,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups_rounded,
              // color: Colors.white,
              size: 20,
            ),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.layers_rounded,
              // color: Colors.black,
              size: 20,
            ),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_repair_service,
              // color: Colors.white,
              size: 20,
            ),
            label: 'Opportunities',
          ),
        ],
      ),
    );
  }
}
