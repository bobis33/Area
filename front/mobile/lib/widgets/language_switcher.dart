import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/models/common.dart';
import '/services/storage.dart';

Widget languageSwitcher(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.language),
    title: Text(translate('changeLanguage')),
    onTap: () {
      context.pop();
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
                  StorageService().storeItem(StorageKeyEnum.lang.name, LangEnum.en_US.name);
                  context.pop();
                },
              ),
              ListTile(
                title: Text(translate('fr')),
                onTap: () async {
                  await changeLocale(context, LangEnum.fr_FR.name);
                  StorageService().storeItem(StorageKeyEnum.lang.name, LangEnum.fr_FR.name);
                  context.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
