import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/services/auth.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;

  const LoginPage({required this.authService, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? errorMessage;

  Future<void> handleLogin() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    final authResponse = await widget.authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (authResponse.token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate('loginSuccess'),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          duration: const Duration(seconds: 3),
        ),
      );
      widget.authService.storeToken(authResponse.token!);
      Navigator.pushNamed(context, '/home');
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
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: translate('email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: translate('password'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(translate('noAccount')),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
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
