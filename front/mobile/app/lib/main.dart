import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/config/constants.dart';
import '/config/router.dart';
import '/config/themes/themes.dart';
import '/data/sources/storage_service.dart';
import '/presentation/providers/language.dart';
import '/presentation/providers/theme.dart';
import '/presentation/providers/settings_provider.dart';
import 'package:app_links/app_links.dart';

import 'data/models/data.dart';
import 'data/sources/request_service.dart';
import 'presentation/widgets/snack_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final storageService = StorageService();
  final String? savedTheme = await storageService.getItem(StorageKeyEnum.theme.name);
  final String? savedLang = await storageService.getItem(StorageKeyEnum.lang.name);
  final LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: savedLang ?? LangEnum.en_US.name,
    supportedLocales: <String>[LangEnum.en_US.name, LangEnum.fr_FR.name],
  );

  if (savedLang != null) delegate.changeLocale(Locale(savedLang));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            (savedTheme ?? 'light') == 'dark'
                ? darkTheme
                : lightTheme,
          ),
        ),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: LocalizedApp(
        delegate,
        App(),
      ),
    ),
  );
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();

}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  Future<void> linkToGoogle(BuildContext context, String googleToken) async {
    const String endpoint = '/auth/link/google';
    final _requestService = RequestService();
    final _storageService = StorageService();
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);

    try {
      final response = await _requestService.makeRequest<String>(
        endpoint: '$endpoint?google_token=$googleToken',
        method: 'POST',
        parse: (response) => response.body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is DataSuccess) {
        snackBar(context, translate('linkGoogleSuccess'), Theme.of(context).colorScheme.secondary);
      } else if (response is DataError) {
        snackBar(context, response.error ?? translate('anErrorOccurred'), Theme.of(context).colorScheme.error);
      }
    } catch (error) {
      debugPrint('Erreur lors de la requête: $error');
    }
  }

  void _initDeepLinkListener() async {
    final appLinks = AppLinks();
    final sub =  appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
      // json decode
        final googleToken = uri.queryParameters['google_token'];
        RegExp exp = RegExp(r"'access_token':\s*\+?'([^']+)'");
        final match = exp.firstMatch(googleToken!);
        print(match![1]);

        linkToGoogle(context, match![1]!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final LocalizationDelegate localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'AREA',
            debugShowCheckedModeBanner: false,
            locale: localizationDelegate.currentLocale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            theme: themeProvider.themeData,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
