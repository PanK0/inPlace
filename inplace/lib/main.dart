import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const InPlace());
}

class InPlace extends StatelessWidget {
  const InPlace({Key? key}) : super(key: key);

  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    // Map Section, where the map should be placed inside the homepage of the application
    Widget mapSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text('HERE COMES THE MAP'),
                ),
                Image.asset(
                  'images/map.png',
                  fit: BoxFit.cover,
                ), // Image.asset: when the app will be completed, here will be inserted the real map instead of the picture
              ],
            ),
          ),
        ],
      ), // Row 1, that contains the map
    ); // mapSection

    // Messages Section, where the messages should appear
    final wordPair = WordPair.random();

    Widget msgSection = Container(
      padding: const EdgeInsets.all(0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButtonColumn(
                    color, Icons.add_circle_outline, 'NEW MESSAGE'),
                _buildButtonColumn(color, Icons.refresh, '  REFRESH  '),
              ],
            ), // Row 2.1.1 for the buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(wordPair.asPascalCase),
                ),
              ],
            ), // Row 2.1.2 for the messages
          ] // children of the Column: should be the two rows, one for the buttons and one for the messages
          ), // Column 2.1 inside which there will be two rows: one for the message buttons and one for the messages
    ); // msgSection Container 2

    // in the MaterialApp() must be added the widgets created in the build() in order to show them in the GUI
    return MaterialApp(
      title: 'inPlace Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData - To determine the theme of the application
      home: Scaffold(
        appBar: AppBar(
          title: const Text('inPlace'),
        ), // AppBar - where the title of the app is present
        body: ListView(
          children: [
            mapSection,
            msgSection,
          ], // Children: all the widgets that are inserted in the homepage
        ), // Center
      ), // Scaffold
    ); // MaterialApp
  } // build

  // Function to automatically generate a colon containing a button
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ), // Text
        ), // Container
      ], // children
    ); // return Column
  } // _buildButtonColumn

  Container _buildMsgList() {
    final suggestions = <WordPair>[];
    const biggerFont = TextStyle(fontSize: 18);

    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: const Text('BANANA'),
    );
  }

  // THIS DOESN'T WORK
  randomMessages() {
    final suggestions = <WordPair>[];
    const biggerFont = TextStyle(fontSize: 18);

    @override
    Widget build(BuildContext context) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(10));
          }
          return ListTile(
            title: Text(
              suggestions[index].asPascalCase,
              style: biggerFont,
            ),
          );
        },
      );
    }
  } // randomMessages()

}
