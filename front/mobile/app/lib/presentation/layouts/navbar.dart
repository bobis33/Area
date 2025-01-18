import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
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
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
      height: 80,
      color: theme.colorScheme.surface,
        child: BottomNavigationBar(
          elevation: 0,
          unselectedItemColor: theme.colorScheme.tertiary,
          selectedItemColor: _selectedIndex == null ? theme.colorScheme.tertiary : theme.colorScheme.primary,
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex ?? 0,
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
              icon: Icon(Icons.add, size: 42),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 40),
              label: 'Browse',
            ),
          ],
          selectedLabelStyle: _selectedIndex == null
              ? const TextStyle(color: Colors.transparent)
              : const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
