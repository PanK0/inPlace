import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

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

// Messages Section widget
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
