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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;

  Future<void> handleRegister(BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      errorMessage = translate('emailInvalid');
      return;
    }
    if (password.isEmpty || confirmPassword.isEmpty) {
      errorMessage = translate('passwordInvalid');
      return;
    }
    if (password != confirmPassword) {
      errorMessage = translate('passwordMismatch');
      return;
    }

    final authResponse = await AuthService().registerUser(email, password);
    if (authResponse is DataSuccess) {
      snackBar(context, translate('registerSuccess'), Theme.of(context).colorScheme.secondary);
      context.go(context.namedLocation(RouteEnum.login.name));
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
          title: translate('register'),
          formFields: [
            textField(controller: emailController, label: translate('email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            textField(controller: passwordController, label: translate('password'), obscureText: true),
            const SizedBox(height: 16),
            textField(controller: confirmPasswordController, label: translate('passwordConfirmation'), obscureText: true),
          ],
          primaryButtonText: translate('register'),
          onPrimaryButtonPressed: () => handleRegister(context),
          footerText: translate('alreadyHaveAccount'),
          footerActionText: translate('login'),
          onFooterActionPressed: () => context.go(context.namedLocation(RouteEnum.login.name)),
          errorMessage: errorMessage,
        );
      },
    );
  }
}
