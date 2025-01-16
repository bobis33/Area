import 'dart:convert';
import 'package:area_front_mobile/config/constants.dart';
import 'package:area_front_mobile/presentation/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/data/models/data.dart';
import '/data/sources/storage_service.dart';
import '/data/sources/request_service.dart';
import '/presentation/providers/language.dart';
import '/presentation/providers/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? errorMessage;
  bool showAreas = true;

  final StorageService _storageService = StorageService();
  final RequestService _requestService = const RequestService();
  String? savedTheme;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    savedTheme = await _storageService.getItem(StorageKeyEnum.theme.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceTint,
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'IstokWeb',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: theme.colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
            toolbarHeight: 80,
            backgroundColor: theme.colorScheme.surfaceContainerHighest
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
              title: Text(
                'Light theme',
                style: TextStyle(
                fontFamily: 'IstokWeb',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
                ),
              ),
              trailing: Switch(
                value: savedTheme == 'dark',
                onChanged: (value) async {
                final newTheme = value ? 'dark' : 'light';
                themeProvider.toggleTheme();
                await _storageService.storeItem(StorageKeyEnum.theme.name, newTheme);
                  setState(() {
                    savedTheme = newTheme;
                  });
                },
              ),
              ),
            ],
          ),
        );
      },
    );
  }
}