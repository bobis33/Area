import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/layouts/main_layout.dart';
import '/models/common.dart';
import '/providers/theme_provider.dart';
import '/styles/color_schemes.g.dart';
import '/styles/text_themes.g.dart';
import '/screens/home.dart';
import '/screens/index.dart';
import '/screens/login.dart';
import '/screens/register.dart';
import '/services/auth.dart';
import '/services/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String? savedTheme = await StorageService().loadTheme();
  final String? savedLang = await StorageService().loadLang();

  final LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: savedLang ?? LangEnum.en_US.name,
    supportedLocales: <String>[LangEnum.en_US.name, LangEnum.fr_FR.name],
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(
        (savedTheme ?? 'light') == 'dark'
            ? ThemeData(useMaterial3: true, colorScheme: darkColorScheme, textTheme: textTheme)
            : ThemeData(useMaterial3: true, colorScheme: lightColorScheme, textTheme: textTheme),
      ),
      child: LocalizedApp(
        delegate,
        App(lang: savedLang),
      ),
    ),
  );
}

class App extends StatelessWidget {
    final String? lang;
   const App({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    final LocalizationDelegate localizationDelegate = LocalizedApp.of(context).delegate;
    final AuthService authService = AuthService();
    if (lang != null) {
      localizationDelegate.changeLocale(Locale(lang!));
    }

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
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

            home: SafeArea(
              child: IndexPage(authService: authService),
            ),
            routes: {
              '/register': (context) => MainLayout(child: RegisterPage(authService: authService)),
              '/login': (context) => MainLayout(child: LoginPage(authService: authService)),
              '/home': (context) => MainLayout(child: HomePage()),
            },
          );
        },
      ),
    );
  }
}

class AuthRedirection extends StatelessWidget {
  final AuthService authService;

  const AuthRedirection({required this.authService, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        } else {
          return LoginPage(authService: authService);
        }
      },
    );
  }
}
