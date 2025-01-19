import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/config/constants.dart';
import '/config/router.dart';
import '/config/themes/themes.dart';
import '/data/listeners/deep_link.dart';
import '/data/sources/storage_service.dart';
import '/presentation/providers/language.dart';
import '/presentation/providers/theme.dart';
import '/presentation/providers/settings_provider.dart';
import 'package:app_links/app_links.dart';

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
        _App(),
      ),
    ),
  );
}

class _App extends StatefulWidget {
  const _App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {

  @override
  void initState() {
    super.initState();
    DeepLinkListener().initDeepLinkListener(context);
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
