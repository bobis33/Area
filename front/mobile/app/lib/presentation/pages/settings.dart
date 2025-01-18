import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/presentation/widgets/language_switcher.dart';
import '/presentation/widgets/theme_switcher.dart';
import '/presentation/layouts/appbar.dart';
import '/presentation/providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceTint,
      appBar: CustomAppBar(
        title: translate('settings'),
        hideAccountButton: true,
        hideSettingsButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          languageSwitcher(context),
          themeSwitcher(context),
          const SizedBox(height: 16),
          _ApiAddressField(settingsProvider: settingsProvider),
        ],
      ),
    );
  }
}

class _ApiAddressField extends StatefulWidget {
  final SettingsProvider settingsProvider;

  const _ApiAddressField({required this.settingsProvider});

  @override
  State<_ApiAddressField> createState() => _ApiAddressFieldState();
}

class _ApiAddressFieldState extends State<_ApiAddressField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.settingsProvider.apiAddress,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveApiAddress() {
    final newApiAddress = _controller.text.trim();
    widget.settingsProvider.updateApiAddress(newApiAddress);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('API address updated to $newApiAddress')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('apiAddress'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: translate('enterApiAddress'),
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveApiAddress,
            ),
          ),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }
}
