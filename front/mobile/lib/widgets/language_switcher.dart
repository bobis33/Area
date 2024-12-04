import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/providers/language.dart';
import '/models/common.dart';
import '/services/storage.dart';

Widget languageSwitcher(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.language),
    title: Text(translate('changeLanguage')),
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(translate('changeLanguage')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(translate('english')),
                onTap: () async {
                  await changeLocale(context, LangEnum.en_US.name);
                  context.read<LanguageProvider>().rebuild();
                  StorageService().storeItem(StorageKeyEnum.lang.name, LangEnum.en_US.name);
                  context.pop(context);
                },
              ),
              ListTile(
                title: Text(translate('french')),
                onTap: () async {
                  await changeLocale(context, LangEnum.fr_FR.name);
                  context.read<LanguageProvider>().rebuild();
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
