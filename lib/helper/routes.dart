import 'package:flutter/material.dart';

class PageNavigator {
  PageNavigator({this.ctx});
  BuildContext? ctx;

  void nextPage({Widget? page}) {
    Navigator.pushAndRemoveUntil(
        ctx!, MaterialPageRoute(builder: (context) => page!), (route) => false);
  }
}
