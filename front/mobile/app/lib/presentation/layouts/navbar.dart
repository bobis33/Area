import 'package:area_front_mobile/presentation/pages/areas.dart';
import 'package:area_front_mobile/presentation/pages/browse.dart';
import 'package:area_front_mobile/presentation/pages/create.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int? _selectedIndex; // Null when no item is selected

  // Define the navbar routes
  final List<String> _navbarRoutes = [
    '/areas',
    '/create',
    '/browse',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update the _selectedIndex based on the current route if it matches a navbar route
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    final navbarIndex = _navbarRoutes.indexOf(currentLocation);
    setState(() {
      _selectedIndex = navbarIndex != -1 ? navbarIndex : null; // Set index or null if not found
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_navbarRoutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // Render the current page from GoRouter
      bottomNavigationBar: Container(
        height: 110,
        color: const Color(0xFF1A1A1A),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BottomNavigationBar(
            unselectedItemColor: const Color(0xFF646464),
            selectedItemColor: _selectedIndex == null ? const Color(0xFF646464) : const Color(0xFF0084FF),
            backgroundColor: const Color(0xFF1A1A1A),
            currentIndex: _selectedIndex ?? 0, // Default to 0 for rendering but no button visually highlighted
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(5),
                  child: ImageIcon(
                    AssetImage('assets/images/puzzle.png'),
                    size: 30,
                  ),
                ),
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
            selectedLabelStyle: _selectedIndex == null
                ? const TextStyle(color: Colors.transparent) // Hide label when no selection
                : const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
