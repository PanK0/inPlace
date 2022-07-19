import 'package:flutter/material.dart';

import 'package:inplace/widget/mapSection_widget.dart';
import 'package:inplace/widget/msgSection_widget.dart';
import 'package:inplace/widget/btnSection_widget.dart';

// Central class where the home resides
class Hermes extends StatefulWidget {
  const Hermes({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HermesState();
}

class _HermesState extends State<Hermes> {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    // This regulates the pressing of the menu icon: opens a new page in the app
    void _gotoSettings() {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('inPlace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _gotoSettings,
            tooltip: 'Menu',
          ) // Icon for settings
        ],
      ), // AppBar - where the title of the app is present
      body: ListView(
        children: [
          mapSection, // Show the map here
          const BtnSectionWidget(), // Show the buttons for new message and refresh messages here
          msgSection, // Show the messages in a place here
        ], // Children: all the widgets that are inserted in the homepage
      ), // ListView
    ); // Scaffold
  }
}
