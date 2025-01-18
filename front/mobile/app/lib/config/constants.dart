import 'package:flutter_dotenv/flutter_dotenv.dart';

enum LangEnum {
  // ignore: constant_identifier_names
  en_US,
  // ignore: constant_identifier_names
  fr_FR
}

enum RouteEnum {
  about,
  areas,
  login,
  profile,
  register,
  root,
  create,
  browse,
  settings,
}

enum StorageKeyEnum {
  authToken,
  lang,
  theme
}

final String apiUrl = dotenv.env['API_URL']!;
