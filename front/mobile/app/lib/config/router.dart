import 'package:area_front_mobile/presentation/pages/create.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/presentation/pages/browse.dart';
import '/presentation/pages/settings.dart';
import '/config/constants.dart';
import '/presentation/layouts/navbar.dart';
import '/presentation/pages/areas.dart';
import '/presentation/pages/login.dart';
import '/presentation/pages/profile.dart';
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
      name: RouteEnum.areas.name,
      path: '/areas',
      builder: (context, state) => MainLayout(child: AreasPage()),
    ),
    GoRoute(
      name: RouteEnum.login.name,
      path: '/login',
      builder: (context, state) => Scaffold(body: LoginPage()),
    ),
    GoRoute(
      name: RouteEnum.settings.name,
      path: '/settings',
      builder: (context, state) => Scaffold(body: SettingsPage()),
    ),
    GoRoute(
      name: RouteEnum.profile.name,
      path: '/profile',
      builder: (context, state) => MainLayout(child: ProfilePage()),
    ),
    GoRoute(
      name: RouteEnum.register.name,
      path: '/register',
      builder: (context, state) => Scaffold(body: RegisterPage()),
    ),
    GoRoute(
      name: RouteEnum.create.name,
      path: '/create',
      builder: (context, state) => MainLayout(child: CreatePage()),
    ),
    GoRoute(
      name: RouteEnum.browse.name,
      path: '/browse',
      builder: (context, state) => MainLayout(child: BrowsePage()),
    ),
  ],
);
