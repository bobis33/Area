import 'package:area_front_mobile/data/models/data.dart';
import 'package:area_front_mobile/presentation/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/config/api_config.dart';
import '/data/sources/request_service.dart';
import '/data/sources/storage_service.dart';


Future<Map<String, String>> fetchSocialIcons() async {
  final apiUrl = ApiConfig().apiUrl;
  return {
    'discord': '$apiUrl/assets/discord.png',
    'github': '$apiUrl/assets/github.png',
    'google': '$apiUrl/assets/google.png',
    'microsoft': '$apiUrl/assets/microsoft.png',
  };
}

  Future<void> loginToGoogle(BuildContext context) async {
    final _requestService = RequestService();
    final _storageService = StorageService();
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);

    try {
      final response = await _requestService.makeRequest<String>(
        endpoint: '/auth/login/to/google',
        method: 'GET',
        parse: (response) => response.body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is DataSuccess) {
        snackBar(context, translate('loginToGoogleSuccess'), Theme.of(context).colorScheme.secondary);
      } else if (response is DataError) {
        snackBar(context, response.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
      }
    } catch (error) {
      debugPrint('Erreur lors de la requête: $error');
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
              onPressed: () {
                loginToGoogle(context);
              },
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
