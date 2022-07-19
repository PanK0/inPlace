import 'package:flutter/material.dart';

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