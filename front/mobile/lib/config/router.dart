import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/presentation/layouts/main.dart';
import '/presentation/pages/areas.dart';
import '/presentation/pages/home.dart';
import '/presentation/pages/login.dart';
import '/presentation/pages/register.dart';
import '/presentation/pages/root.dart';

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
    GoRoute(
      name: RouteEnum.areas.name,
      path: '/areas',
      builder: (context, state) => MainLayout(child: AreasPage()),
    ),
  ],
);
