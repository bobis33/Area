import 'package:go_router/go_router.dart';

import '/layouts/main.dart';
import '/models/common.dart';
import '/screens/home.dart';
import '/screens/login.dart';
import '/screens/register.dart';
import '/screens/root.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: RouteEnum.root.name,
      path: '/',
      builder: (context, state) => RootPage(),
    ),
    GoRoute(
      name: RouteEnum.login.name,
      path: '/login',
      builder: (context, state) => MainLayout(child: LoginPage()),
    ),
    GoRoute(
      name: RouteEnum.register.name,
      path: '/register',
      builder: (context, state) => MainLayout(child: RegisterPage()),
    ),
    GoRoute(
      name: RouteEnum.home.name,
      path: '/home',
      builder: (context, state) => MainLayout(child: HomePage()),
    ),
  ],
);
