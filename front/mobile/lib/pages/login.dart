import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/models/common.dart';
import '/models/data.dart';
import '/providers/language.dart';
import '/services/auth.dart';
import '/widgets/auth_base.dart';
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

  Future<void> handleLogin(BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      errorMessage = translate('emailInvalid');
      return;
    }
    if (password.isEmpty) {
      errorMessage = translate('passwordInvalid');
      return;
    }

    final authResponse = await AuthService().loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (authResponse is DataSuccess) {
      snackBar(context, translate('loginSuccess'), Theme.of(context).colorScheme.secondary);
      context.go(context.namedLocation(RouteEnum.home.name));
    } else if (authResponse is DataError) {
      setState(() {
        errorMessage = authResponse.error ?? translate('anErrorOccurred');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return AuthPage(
          title: translate('login'),
          formFields: [
            textField(controller: emailController, label: translate('email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            textField(controller: passwordController, label: translate('password'), obscureText: true),
          ],
          primaryButtonText: translate('login'),
          onPrimaryButtonPressed: () => handleLogin(context),
          footerText: translate('noAccount'),
          footerActionText: translate('register'),
          onFooterActionPressed: () => context.go(context.namedLocation(RouteEnum.register.name)),
          errorMessage: errorMessage,
        );
      },
    );
  }
}
