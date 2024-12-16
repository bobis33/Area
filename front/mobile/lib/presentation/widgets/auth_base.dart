import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final String footerText;
  final String footerActionText;
  final VoidCallback onFooterActionPressed;
  final String? errorMessage;

  const AuthPage({
    super.key,
    required this.title,
    required this.formFields,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    required this.footerText,
    required this.footerActionText,
    required this.onFooterActionPressed,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              'shared_assets/icon.png',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...formFields,
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onPrimaryButtonPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: theme.colorScheme.primary,
            ),
            child: Text(
              primaryButtonText,
              style: const TextStyle(
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
              Text(footerText),
              TextButton(
                onPressed: onFooterActionPressed,
                child: Text(footerActionText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
