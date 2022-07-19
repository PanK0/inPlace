import 'package:flutter/material.dart';
import 'package:inplace/page/home_page.dart';

void main() {
  runApp(const InPlace());
}

class InPlace extends StatelessWidget {
  const InPlace({Key? key}) : super(key: key);

  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    // in the MaterialApp() must be added the widgets created in the build() in order to show them in the GUI
    return MaterialApp(
      title: 'inPlace Messaging App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Hermes(),
    ); // MaterialApp
  } // build

} // class InPlace




