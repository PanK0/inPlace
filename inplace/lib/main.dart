import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      ), // Row that contains the map
    ); // mapSection

    // Button Section, where the buttons should appear
    Widget btnSection = Container(
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
          ), // Row for the buttons
        ], // children of the Column
      ), // Column inside which there is the row for the buttons
    ); // btnSection Container

    // Messages Section
    Widget msgSection = Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 400, child: MsgList()),
        ], // Children of the column, containing the widget that show the messages
      ), // Column containing the messages
    ); // Container

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
            mapSection, // Show the map here
            btnSection, // Show the buttons for new message and refresh messages here
            msgSection, // Show the messages in a place here
          ], // Children: all the widgets that are inserted in the homepage
        ), // ListView
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

} // class InPlace

// MsgList stateful widget, to create the infinite message box
class MsgList extends StatefulWidget {
  const MsgList({super.key});

  @override
  State<MsgList> createState() => _MsgList();
}

class _MsgList extends State<MsgList> {
  final suggestions = <WordPair>[];
  final biggerFont = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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
}
