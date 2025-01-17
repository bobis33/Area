import 'package:area_front_mobile/presentation/pages/profile.dart';
import 'package:area_front_mobile/presentation/pages/settings.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hideAccountButton;
  final bool hideSettingsButton;

  CustomAppBar({
    required this.title,
    this.hideAccountButton = false,
    this.hideSettingsButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'IstokWeb',
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      leading: hideAccountButton
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Semantics(
                label: 'Account button',
                button: true,
                enabled: true,
                excludeSemantics: true,
                child: IconButton(
                  icon: Icon(Icons.account_circle, color: theme.colorScheme.onSurface, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                ),
              ),
            ),
      actions: [
        if (!hideSettingsButton)
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Semantics(
              label: 'Settings button',
              button: true,
              enabled: true,
              excludeSemantics: true,
              child: IconButton(
                icon: Icon(Icons.settings, color: theme.colorScheme.onSurface, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}