import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/models/user.dart';
import '/data/repositories/auth.dart';
import '/domain/use-cases/auth.dart';
import '/presentation/providers/language.dart';
import '/presentation/widgets/auth_base.dart';
import '/presentation/widgets/snack_bar.dart';
import '/presentation/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;

  Future<void> handleRegister(BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty) {
      errorMessage = translate('usernameInvalid');
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

    final authResponse = await RegisterUser(AuthRepositoryImpl()).execute(User(username: username, password: password));
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
            textField(controller: usernameController, label: translate('username'), keyboardType: TextInputType.emailAddress),
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
          oauthButtons: false,
          errorMessage: errorMessage,
        );
      },
    );
  }
}
