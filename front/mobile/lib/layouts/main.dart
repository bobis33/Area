import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/models/common.dart';
import '/services/auth.dart';
import '/services/storage.dart';
import '/widgets/language_switcher.dart';
import '/widgets/theme_switcher.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
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
                    onTap: () => context.go(context.namedLocation(RouteEnum.home.name)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(translate('logout')),
                    onTap: () async {
                      await StorageService().clearItem(StorageKeyEnum.authToken.name);
                      context.go(context.namedLocation(RouteEnum.root.name));
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: Text(translate('login')),
                    onTap: () => context.go(context.namedLocation(RouteEnum.login.name)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: Text(translate('register')),
                    onTap: () => context.go(context.namedLocation(RouteEnum.register.name)),
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
      body: SafeArea(child: child),
    );
  }
}
