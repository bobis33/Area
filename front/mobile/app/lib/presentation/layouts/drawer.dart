import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/models/user.dart';
import '/data/repositories/user.dart';
import '/data/sources/storage_service.dart';
import '/domain/use-cases/user.dart';
import '/presentation/widgets/language_switcher.dart';
import '/presentation/widgets/snack_bar.dart';
import '/presentation/widgets/theme_switcher.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: FutureBuilder<DataState<User>>(
        future: GetUser(UserRepositoryImpl()).execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Drawer(
              child: Center(child: Text(translate('failedToLoadUser'))),
            );
          }

          final user = snapshot.data;
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: user is DataSuccess<User>
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('$apiUrl/assets/avatar.png'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.data?.username ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        user.data?.email ?? '',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ) : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/default_avatar.png'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(translate('welcome'), style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 5),
                      Text(
                        translate('loginToAccess'),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (user is DataSuccess<User>) ...[
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(translate('home')),
                    onTap: () => context.go(context.namedLocation(RouteEnum.home.name)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.device_hub),
                    title: Text(translate('areas')),
                    onTap: () => context.go(context.namedLocation(RouteEnum.areas.name)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(translate('profile')),
                    onTap: () => context.go(context.namedLocation(RouteEnum.profile.name)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(translate('logout')),
                    onTap: () async {
                      await StorageService().clearItem(StorageKeyEnum.authToken.name);
                      snackBar(context, translate('logoutSuccess'), Theme.of(context).colorScheme.secondary);
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
