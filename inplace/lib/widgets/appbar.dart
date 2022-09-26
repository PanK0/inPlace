import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return AppBar(
    title: const Text('inPlace'),
  );
}
