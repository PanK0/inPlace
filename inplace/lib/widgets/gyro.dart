import 'package:flutter/material.dart';
import 'package:inplace/widgets/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class Gyro extends StatefulWidget {
  @override
  _GyroState createState() => _GyroState();
}

class _GyroState extends State<Gyro> {
  double x = 0, y = 0, z = 0;
  String direction = "none";

  @override
  void initState() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      print(event);

      x = event.x;
      y = event.y;
      z = event.z;

      //rough calculation, you can use
      //advance formula to calculate the orentation
      if (x > 0) {
        direction = "back";
      } else if (x < 0) {
        direction = "forward";
      } else if (y > 0) {
        direction = "left";
      } else if (y < 0) {
        direction = "right";
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Paragraph(
      direction,
    );
  }
}
