import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(BuildContext context, String message, Color backgroundColor) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    ),
  );
}
