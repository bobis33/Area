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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        context.go(context.namedLocation(RouteEnum.areas.name));
        break;
      case 1:
        context.go(context.namedLocation("create"));
        break;
      case 2:
        context.go(context.namedLocation("browse"));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
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
