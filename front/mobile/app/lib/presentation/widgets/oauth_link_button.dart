import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class OauthLinkButton extends StatelessWidget {
  final String iconUrl;
  final String text;
  final String authUrl;
  final String callbackUrlScheme;
  final Future<void> Function(BuildContext context, String token) onAuthSuccess;
  final Color backgroundColor;

  const OauthLinkButton({
    super.key,
    required this.iconUrl,
    required this.text,
    required this.authUrl,
    required this.callbackUrlScheme,
    required this.onAuthSuccess,
    this.backgroundColor = Colors.blue,
  });

  Future<void> _handleAuth(BuildContext context) async {
    try {
      final String result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme,
      );
      final Uri resultUri = Uri.parse(result);
      final String? token = resultUri.queryParameters['token']; // Change "token" if your backend uses a different query parameter
      if (token != null) {
        await onAuthSuccess(context, token);
      } else {
        throw Exception('Token manquant');
      }
    } catch (error) {
      debugPrint('Erreur lors de la connexion : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleAuth(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              iconUrl,
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.white, size: 24);
              },
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
