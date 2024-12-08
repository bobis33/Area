import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/config/router.dart';
import '/config/themes/themes.dart';
import '/models/common.dart';
import '/providers/language.dart';
import '/providers/theme.dart';
import '/services/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String? savedTheme = await StorageService().getItem(StorageKeyEnum.theme.name);
  final String? savedLang = await StorageService().getItem(StorageKeyEnum.lang.name);
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
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: LocalizedApp(
        delegate,
        const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

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
