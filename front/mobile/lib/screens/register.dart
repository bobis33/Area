import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/models/common.dart';
import '/services/auth.dart';
import '/widgets/snack_bar.dart';
import '/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final colorScheme = Theme.of(context).colorScheme;

    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        emailError = translate('invalidEmail');
      });
      return;
    }
    if (password != confirmPasswordController.text.trim()) {
      setState(() {
        passwordError = translate('passwordMismatch');
      });
      return;
    }

    final authResponse = await AuthService().registerUser(email, password);

    if (authResponse.token != null) {
      snackBar(context, translate('registerSuccess'), colorScheme.secondary);
      context.go(context.namedLocation(RouteEnum.login.name));
    } else {
      snackBar(context, authResponse.error ?? translate('anErrorOccurred'), colorScheme.error);
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
          children: [
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
              translate('register'),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            textField(
              controller: emailController,
              label: translate('email'),
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            textField(
              controller: passwordController,
              label: translate('password'),
              errorText: passwordError,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            textField(
              controller: confirmPasswordController,
              label: translate('passwordConfirmation'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleRegister,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                translate('register'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(translate('alreadyHaveAccount')),
                TextButton(
                  onPressed: () {
                    context.go(context.namedLocation(RouteEnum.login.name));
                  },
                  child: Text(translate('login')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
