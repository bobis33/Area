import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/models/common.dart';
import '/styles/color_schemes.g.dart';
import '/styles/text_themes.g.dart';
import '/screens/login.dart';
import '/screens/register.dart';
import '/screens/home.dart';
import '/screens/index.dart';
import '/services/auth.dart';

Future<void> main() async {
  final LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: LangEnum.en_US.name,
    supportedLocales: <String>[LangEnum.en_US.name, LangEnum.fr_FR.name],
  );

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    LocalizedApp(
      delegate,
      const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalizationDelegate localizationDelegate = LocalizedApp.of(context).delegate;
    final AuthService authService = AuthService(baseUrl: 'http://localhost:5000');

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'AREA',
        debugShowCheckedModeBanner: false,
        locale: localizationDelegate.currentLocale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, textTheme: textTheme),
        home: SafeArea(
          child: IndexPage(authService: authService),
        ),
        routes: {
          '/register': (context) => RegisterPage(authService: authService),
          '/login': (context) => LoginPage(authService: authService),
          '/home': (context) => HomePage(authService: authService),
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
          return HomePage(authService: authService);
        } else {
          return LoginPage(authService: authService);
        }
      },
    );
  }
}
