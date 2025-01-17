import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:url_launcher/url_launcher.dart';

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
      print("aaaaaaaaaaaaaaaaaaaaaa");
      if (await canLaunchUrl(Uri.parse(authUrl))) {
        await launchUrl(Uri.parse(authUrl));
      } else {
        throw Exception('Impossible de lancer l\'URL');
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
