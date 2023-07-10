import 'package:flutter/material.dart';

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 980.0;
}

bool isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}
