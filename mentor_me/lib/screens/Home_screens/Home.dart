// This file contains the user's Home screen

import 'package:flutter/material.dart';

import '../message_screens/chats.dart';
import 'home_page.dart';
import 'connections_page.dart';
import 'resources_page.dart';
import 'opportunities_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double radius = 50;
  int _pageIndex = 0;
  final List<Widget> _pages = [
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
            ? ((_pageIndex != 1) ? _pages[_pageIndex - 2] : ConnectionsPage())
            : HomePage(),
      ),
      floatingActionButton: (_pageIndex == 1)
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (((context) => ChatsThemeLoader())),
                    ),
                  );
                });
              },
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
        onTap: (value) async {
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
