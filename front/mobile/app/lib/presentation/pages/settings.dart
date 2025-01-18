import 'package:flutter/material.dart';

import '/presentation/widgets/language_switcher.dart';
import '/presentation/widgets/theme_switcher.dart';
import '/presentation/layouts/appbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
          backgroundColor: theme.colorScheme.surfaceTint,
          appBar: const CustomAppBar(
            title: "Settings",
            hideAccountButton: true,
            hideSettingsButton: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              languageSwitcher(context),
              themeSwitcher(context),
            ],
          ),
    );
  }
}