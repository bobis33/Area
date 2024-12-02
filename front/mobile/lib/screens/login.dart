import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/models/common.dart';
import '/services/auth.dart';
import '/services/storage.dart';
import '/widgets/snack_bar.dart';
import '/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> handleLogin() async {
    setState(() {
      errorMessage = null;
    });

    final authResponse = await AuthService().loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (authResponse.token != null) {
      snackBar(context, translate('loginSuccess'), Theme.of(context).colorScheme.secondary);
      StorageService().storeItem(StorageKeyEnum.authToken.name, authResponse.token!);
      context.go(context.namedLocation(RouteEnum.home.name));
    } else {
      setState(() {
        errorMessage = authResponse.error ?? translate('anErrorOccurred');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets_shared/images/icon.png',
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              translate('login'),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            textField(controller: emailController, label: translate('email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            textField(controller: passwordController, label: translate('password'), obscureText: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                translate('login'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(translate('noAccount')),
                TextButton(
                  onPressed: () {
                    context.go(context.namedLocation(RouteEnum.register.name));
                  },
                  child: Text(translate('register')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
