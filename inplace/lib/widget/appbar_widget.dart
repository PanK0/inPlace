import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inplace/utils/gotoSettings.dart';

AppBar buildAppBar(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    title: const Text('inPlace'),
    backgroundColor: Colors.blue,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          gotoSettings(context);
        },
        tooltip: 'Menu',
      ) // Icon for settings
    ],
  );
}
