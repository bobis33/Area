import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/models/user.dart';
import '/data/repositories/user.dart';
import '/data/sources/storage_service.dart';
import '/domain/use-cases/user.dart';
import '/presentation/widgets/text_field.dart';
import '/presentation/widgets/snack_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _initialUsername = '';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() async {
    await _loadUserData();
    setState(() {
      _usernameController.text = _initialUsername;
    });
  }

  Future<void> _loadUserData() async {
    try {
      final userResponse = await GetUser(UserRepositoryImpl()).execute();
      if (userResponse is DataSuccess<User>) {
        final user = userResponse.data;
        setState(() {
          _initialUsername = user!.username;
          _usernameController.text = _initialUsername;
        });
      } else if (userResponse is DataError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load user data: ${userResponse.error}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load user data: $e")),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changeAvatar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('changeAvatar')),
        content: const Text('This feature is under development.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _submitChanges() async {
    bool isUpdated = false;

    if (_usernameController.text != _initialUsername) {
      var shouldProceed = false;
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(translate('changeUsername')),
          content: Text(translate('changeUsernameInfo')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                shouldProceed = false;
              },
              child: Text(translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                shouldProceed = true;
              },
              child: Text(translate('proceed')),
            ),
          ],
        ),
      );

      if (shouldProceed != true) {
        return;
      }

      _initialUsername = _usernameController.text;
      final updateUsernameResponse = await UpdateUsername(UserRepositoryImpl()).execute(_initialUsername);

      if (updateUsernameResponse is DataSuccess<String>) {
        snackBar(context, "Username updated to: $_initialUsername", Theme.of(context).colorScheme.secondary);
        isUpdated = true;
        context.go(context.namedLocation(RouteEnum.login.name));
        StorageService().clearItem(StorageKeyEnum.authToken.name);
      } else if (updateUsernameResponse is DataError) {
        snackBar(context, "Failed to update username: ${updateUsernameResponse.error}", Theme.of(context).colorScheme.error);
        return;
      } else {
        snackBar(context, "Failed to update username", Theme.of(context).colorScheme.error);
        return;
      }
    }

    if (_passwordController.text.isNotEmpty || _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text.length < 6) {
        snackBar(context, "Password must be at least 6 characters long", Theme.of(context).colorScheme.error);
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        snackBar(context, "Passwords do not match", Theme.of(context).colorScheme.error);
        return;
      }

      final updatePasswordResponse = await UpdateEmail(UserRepositoryImpl())
          .execute(_passwordController.text);
      if (updatePasswordResponse is DataSuccess<String>) {
        snackBar(context, "Password updated", Theme.of(context).colorScheme.secondary);
        isUpdated = true;
      } else if (updatePasswordResponse is DataError) {
        snackBar(context, "Failed to update password: ${updatePasswordResponse.error}", Theme.of(context).colorScheme.error);
      } else {
        snackBar(context, "Failed to update password", Theme.of(context).colorScheme.error);
        return;
      }
    }

    if (!isUpdated) {
      snackBar(context, translate('noChangeToSubmit'), Theme.of(context).colorScheme.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('$apiUrl/assets/avatar.png'), // Replace with user avatar
                  backgroundColor: Colors.grey[300],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeAvatar,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 20,
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                textField(
                  controller: _usernameController,
                  label: translate('username'),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 32),
                textField(
                  controller: _passwordController,
                  label: translate('password'),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                textField(
                  controller: _confirmPasswordController,
                  label: translate('passwordConfirmation'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: _submitChanges,
                  child: Text(translate('submit')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
