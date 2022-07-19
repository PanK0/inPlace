import 'package:flutter/material.dart';
import 'package:inplace/utils/buildButtonColumn.dart';

class BtnSectionWidget extends StatefulWidget {
  const BtnSectionWidget({super.key});

  @override
  State<BtnSectionWidget> createState() => _BtnSectionWidget();
}

class _BtnSectionWidget extends State<BtnSectionWidget> {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildButtonColumn(color, Icons.add_circle_outline, 'NEW MESSAGE'),
          buildButtonColumn(color, Icons.refresh, '  REFRESH  '),
        ],
      ), // Row for the buttons
      // children of the Column
      // Column inside which there is the row for the buttons
    ); // btnSection Container
  }
}
