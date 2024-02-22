// This file contains the user's Home screen

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'connect_screens/message_screens/chats.dart';
import 'home_screens/home_page.dart';
import 'connect_screens/connections_page.dart';
import 'resource_pages/resources_page.dart';
import 'opportunites_screens/opportunities_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(),
      ),
      // body: SingleChildScrollView(
      //   child: (_pageIndex != 0)
      //       ? ((_pageIndex != 1) ? _pages[_pageIndex - 2] : ConnectionsPage())
      //       : HomePage(),
      // ),
      body: ExpandablePageView(
        children: _pages,
        controller: _pageController,
        onPageChanged: (value) => setState(() {
          _pageIndex = value;
        }),
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
        unselectedFontSize: 12,
        selectedFontSize: 13,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) async {
          setState(() {
            _pageIndex = value;
            _pageController.animateToPage(_pageIndex,
                duration: Durations.medium2, curve: Curves.easeIn);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_rounded,
              // color: Colors.black,
              size: 20,
            ),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.groups_rounded,
              // color: Colors.white,
              size: 20,
            ),
            label: AppLocalizations.of(context)!.connections,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.layers_rounded,
              // color: Colors.black,
              size: 20,
            ),
            label: AppLocalizations.of(context)!.resources,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_repair_service,
              // color: Colors.white,
              size: 20,
            ),
            label: AppLocalizations.of(context)!.opp,
          ),
        ],
      ),
    );
  }
}
