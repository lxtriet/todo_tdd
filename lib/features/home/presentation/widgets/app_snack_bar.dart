import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  AppSnackBar._internal({
    required String message,
    required Color backgroundColor,
  }) : super(
          content: Text(message),
          backgroundColor: backgroundColor,
        );

  static Future<void> show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar._internal(
      message: message,
      backgroundColor: backgroundColor,
    ));
  }

  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
  }) =>
      show(context, message: message, backgroundColor: Colors.green);

  static Future<void> showError(
    BuildContext context, {
    required String message,
  }) =>
      show(context, message: message, backgroundColor: Theme.of(context).errorColor);
}
