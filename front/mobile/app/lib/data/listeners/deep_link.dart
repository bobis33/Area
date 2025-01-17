import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:app_links/app_links.dart';

import '/config/constants.dart';
import '/domain/use-cases/auth.dart';
import '/presentation/widgets/snack_bar.dart';
import '/data/models/data.dart';
import '/data/repositories/auth.dart';
import '/data/sources/storage_service.dart';

class DeepLinkListener {

  Future<void> _linkToGoogle(BuildContext context, String googleToken) async {
    try {
      final authResponse = await LinkToGoogle(AuthRepositoryImpl()).execute(googleToken);
      if (authResponse is DataSuccess) {
        snackBar(context, translate('linkGoogleSuccess'), Theme.of(context).colorScheme.secondary);
      } else if (authResponse is DataError) {
        snackBar(context, authResponse.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
      }
    } catch (error) {
      debugPrint('Erreur lors de la requête: $error');
    }
  }

  Future<void> _linkToGithub(BuildContext context, String githubToken) async {
    try {
      final authResponse = await LinkTo(AuthRepositoryImpl()).execute('github?github_token=$githubToken');
      if (authResponse is DataSuccess) {
        snackBar(context, translate('linkGithubSuccess'), Theme.of(context).colorScheme.secondary);
      } else if (authResponse is DataError) {
        snackBar(context, authResponse.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
      }
    } catch (error) {
      debugPrint('Erreur lors de la requête: $error');
    }
  }

  Future<void> _linkToDiscord(BuildContext context, String discordToken) async {
    try {
      final authResponse = await LinkTo(AuthRepositoryImpl()).execute('discord?discord_token=$discordToken');
      if (authResponse is DataSuccess) {
        snackBar(context, translate('linkDiscordSuccess'), Theme.of(context).colorScheme.secondary);
      } else if (authResponse is DataError) {
        snackBar(context, authResponse.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
      }
    } catch (error) {
      debugPrint('Erreur lors de la requête: $error');
    }
  }

  Future<void> _linkToSpotify(BuildContext context, String spotifyToken) async {
    try {
      final authResponse = await LinkTo(AuthRepositoryImpl()).execute('spotify?spotify_token=$spotifyToken');
      if (authResponse is DataSuccess) {
        snackBar(context, translate('linkSpotifySuccess'), Theme.of(context).colorScheme.secondary);
      } else if (authResponse is DataError) {
        snackBar(context, authResponse.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
      }
    } catch (error) {
      debugPrint('Erreur lors de la requête: $error');
    }
  }

  void initDeepLinkListener(BuildContext context) async {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null) return;
      if (uri.queryParameters['google_token'] != null) {
        final googleToken = uri.queryParameters['google_token'];
        RegExp exp = RegExp(r"'access_token':\s*\+?'([^']+)'");
        final match = exp.firstMatch(googleToken!);
        _linkToGoogle(context, match![1]!);
      } else if (uri.queryParameters['github_token'] != null) {
        final googleToken = uri.queryParameters['github_token'];
        RegExp exp = RegExp(r"'access_token':\s*\+?'([^']+)'");
        final match = exp.firstMatch(googleToken!);
        _linkToGithub(context, match![1]!);
      } else if (uri.queryParameters['discord_token'] != null) {
        final googleToken = uri.queryParameters['discord_token'];
        RegExp exp = RegExp(r"'access_token':\s*\+?'([^']+)'");
        final match = exp.firstMatch(googleToken!);
        _linkToDiscord(context, match![1]!);
      } else if (uri.queryParameters['spotify_token'] != null) {
        final googleToken = uri.queryParameters['spotify_token'];
        RegExp exp = RegExp(r"'access_token':\s*\+?'([^']+)'");
        final match = exp.firstMatch(googleToken!);
        _linkToSpotify(context, match![1]!);
      } else if (uri.queryParameters['token'] != null) {
        final token = uri.queryParameters['token'];
        final storageService = StorageService();
        storageService.storeItem(StorageKeyEnum.authToken.name, token!);
      } else {}
    });
  }
}
