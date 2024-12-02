import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/models/common.dart';
import '/services/auth.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return FutureBuilder<bool>(
      future: authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(context.namedLocation(RouteEnum.home.name));
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(context.namedLocation(RouteEnum.login.name));
          });
        }

        return const Scaffold();
      },
    );
  }
}
