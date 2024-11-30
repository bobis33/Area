import 'package:flutter/material.dart';
import 'package:mobile/services/auth.dart';

class IndexPage extends StatelessWidget {
  final AuthService authService;

  const IndexPage({required this.authService, super.key});

  Future<bool> _checkIfLoggedIn() async {
    return await authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }

        return const Scaffold();
      },
    );
  }
}
