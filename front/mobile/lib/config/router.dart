import 'package:go_router/go_router.dart';

import '/layouts/main.dart';
import '/models/common.dart';
import '/pages/home.dart';
import '/pages/login.dart';
import '/pages/register.dart';
import '/pages/root.dart';

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
