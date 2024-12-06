import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/providers/theme.dart';

Widget themeSwitcher(BuildContext context) {
  return SwitchListTile(
    secondary: const Icon(Icons.dark_mode),
    title: Text(translate('theme')),
    value: Theme.of(context).brightness == Brightness.dark,
    onChanged: (_) {
      context.read<ThemeProvider>().toggleTheme();
    },
  );
}
