import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/common.dart';
import '/services/storage.dart';

Widget languageSwitcher(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.language),
    title: Text(translate('changeLanguage')),
    onTap: () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(translate('changeLanguage')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(translate('en')),
                onTap: () async {
                  await changeLocale(context, LangEnum.en_US.name);
                  StorageService().storeLang(LangEnum.en_US.name);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(translate('fr')),
                onTap: () async {
                  await changeLocale(context, LangEnum.fr_FR.name);
                  StorageService().storeLang(LangEnum.fr_FR.name);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
