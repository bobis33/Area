import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/services/auth.dart';
import '/services/storage.dart';
import '/widgets/language_switcher.dart';
import '/widgets/theme_switcher.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(),
      drawer: FutureBuilder<bool>(
        future: authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Drawer(
              child: Center(child: Text(translate('errorLoading'))),
            );
          }

          final bool isLoggedIn = snapshot.data ?? false;

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Text(
                    'AREA',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                if (isLoggedIn) ...[
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(translate('home')),
                    onTap: () => Navigator.pushNamed(context, '/home'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(translate('logout')),
                    onTap: () async {
                      await StorageService().clearToken();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: Text(translate('login')),
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: Text(translate('register')),
                    onTap: () => Navigator.pushNamed(context, '/register'),
                  ),
                ],
                const Divider(),
                languageSwitcher(context),
                themeSwitcher(context),
              ],
            ),
          );
        },
      ),
      body: child,
    );
  }
}
