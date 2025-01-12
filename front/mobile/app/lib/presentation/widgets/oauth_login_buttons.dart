import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/config/constants.dart';

Future<Map<String, String>> fetchSocialIcons() async {
  return {
    'discord': '$apiUrl/assets/discord.png',
    'github': '$apiUrl/assets/github.png',
    'google': '$apiUrl/assets/google.png',
    'microsoft': '$apiUrl/assets/microsoft.png',
  };
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
  return FutureBuilder<Map<String, String>>(
    future: fetchSocialIcons(),
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
              onPressed: () {},
            ),
            _button(
              imageUrl: icons['github']!,
              label: 'GitHub',
              onPressed: () {},
            ),
            _button(
              imageUrl: icons['google']!,
              label: 'Google',
              onPressed: () {},
            ),
            _button(
              imageUrl: icons['microsoft']!,
              label: 'Microsoft',
              onPressed: () {},
            ),
          ],
        );
      }
    },
  );
}
