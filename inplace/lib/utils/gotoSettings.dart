import 'package:flutter/material.dart';

void gotoSettings(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            child: const Text('PUT HERE THE SETTINGS MENU'),
          ), // Container
        ], // Children
      ), // ListView
    ); // Scaffold
  })); // MaterialPageRoute
}
