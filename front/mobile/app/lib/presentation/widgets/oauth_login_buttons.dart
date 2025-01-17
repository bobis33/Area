import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '/config/api_config.dart';

Future<Map<String, String>> _fetchSocialIcons() async {
  final apiUrl = ApiConfig().apiUrl;
  return {
    'discord': '$apiUrl/assets/discord.png',
    'github': '$apiUrl/assets/github.png',
    'google': '$apiUrl/assets/google.png',
    'spotify': '$apiUrl/assets/spotify.png',
  };
}

Future<void> _handleAuth(BuildContext context, String url) async {
  try {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Impossible de lancer l\'URL');
    }
  } catch (error) {
    debugPrint('Erreur lors de la connexion : $error');
  }
}

Widget _button({
  required String imageUrl,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    icon: Image.network(
      imageUrl,
      height: 24,
      width: 24,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error, size: 24);
      },
    ),
    label: Text(label),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}

Widget loginOauthButtons() {
  final apiUrl = ApiConfig().apiUrl;
  return FutureBuilder<Map<String, String>>(
    future: _fetchSocialIcons(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text(translate('errorLoadingIcons'));
      } else {
        final icons = snapshot.data!;
        return Wrap(
          spacing: 16,
          children: [
            _button(
              imageUrl: icons['discord']!,
              label: 'Discord',
              onPressed: () { _handleAuth(context, '$apiUrl/auth/login/with/discord'); },
            ),
            _button(
              imageUrl: icons['github']!,
              label: 'GitHub',
              onPressed: () { _handleAuth(context, '$apiUrl/auth/login/with/github'); },
            ),
            _button(
              imageUrl: icons['google']!,
              label: 'Google',
              onPressed: () { _handleAuth(context, '$apiUrl/auth/login/with/google'); },
            ),
            _button(
              imageUrl: icons['spotify']!,
              label: 'Spotify',
              onPressed: () { _handleAuth(context, '$apiUrl/auth/login/with/spotify'); },
            ),
          ],
        );
      }
    },
  );
}
