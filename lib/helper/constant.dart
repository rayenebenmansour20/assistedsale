import 'package:flutter/material.dart';

class AppIcons {
  static const String emailIcon = 'assets/icons/email.png';
  static const String lockIcon = 'assets/icons/lock.png';
  static const String eyeIcon = 'assets/icons/eye.png';
}

void showMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue));
}
