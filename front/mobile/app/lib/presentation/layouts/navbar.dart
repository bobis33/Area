import 'package:area_front_mobile/presentation/pages/areas.dart';
import 'package:area_front_mobile/presentation/pages/browse.dart';
import 'package:area_front_mobile/presentation/pages/create.dart';
import 'package:area_front_mobile/presentation/pages/home.dart';
import 'package:area_front_mobile/presentation/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/presentation/widgets/language_switcher.dart';
import '/presentation/widgets/snack_bar.dart';
import '/presentation/widgets/theme_switcher.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AreasPage(),
    CreatePage(),
    BrowsePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 110,
        color: Color(0xFF1A1A1A),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BottomNavigationBar(
            unselectedItemColor: Color(0xFF646464),
            selectedItemColor: Color(0xFF0084FF),
            backgroundColor: Color(0xFF1A1A1A),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.all(5), child: ImageIcon(AssetImage('assets/images/puzzle.png'), size: 30)),
                label: 'My AREAS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add, size: 40),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 40),
                label: 'Browse',
              ),
            ],
            selectedLabelStyle: TextStyle(fontSize: 16),
            unselectedLabelStyle: TextStyle(fontSize: 16),
          ),
        )
      ),
    );
  }
}
