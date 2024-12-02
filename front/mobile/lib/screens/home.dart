import 'package:area_front_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/services/storage.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async => {
                await StorageService().clearToken(),
                snackBar(context, translate('logoutSuccess'), Theme.of(context).colorScheme.secondary),
                Navigator.pushReplacementNamed(context, '/'),
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  translate('logout'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
