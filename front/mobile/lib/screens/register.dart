import 'package:area_front_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/services/auth.dart';

class RegisterPage extends StatefulWidget {
  final AuthService authService;

  const RegisterPage({required this.authService, super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? emailError;
  String? passwordError;

  Future<void> handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

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
    if (password != confirmPassword) {
      setState(() {
        passwordError = translate('passwordMismatch');
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authResponse = await widget.authService.registerUser(email, password);

    setState(() {
      _isLoading = false;
    });

    if (authResponse.token != null) {
      snackBar(context, translate('registerSuccess'), Theme.of(context).colorScheme.secondary);
      Navigator.pushNamed(context, '/login');
    } else {
      snackBar(context, authResponse.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
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
            _buildTextField(
              controller: emailController,
              label: translate('email'),
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: passwordController,
              label: translate('password'),
              errorText: passwordError,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: confirmPasswordController,
              label: translate('password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
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
                    Navigator.pop(context);
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
