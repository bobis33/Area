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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> handleLogin(BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty) {
      errorMessage = translate('usernameInvalid');
      return;
    }
    if (password.isEmpty) {
      errorMessage = translate('passwordInvalid');
      return;
    }

    final authResponse = await LoginUser(AuthRepositoryImpl()).execute(User(username: username, password: password));

    if (authResponse is DataSuccess) {
      snackBar(context, translate('loginSuccess'), Theme.of(context).colorScheme.secondary);
      context.go(context.namedLocation(RouteEnum.areas.name));
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
            textField(controller: usernameController, label: translate('username'), keyboardType: TextInputType.name),
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
