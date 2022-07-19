import 'package:flutter/material.dart';

import 'package:inplace/widget/appbar_widget.dart';
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

    return Scaffold(
      appBar: buildAppBar(context),
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
