import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/authentication.dart';
import '../widgets/appbar.dart';
import '../widgets/clusters.dart';
import '../utils/applicationState.dart';
import '../widgets/widgets.dart';

import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

class ClusterPage extends StatelessWidget {
  const ClusterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[
          const Header("Top Clusters"),
          const Paragraph(
            'Clusters in the world',
          ),
          const Divider(
            color: Colors.black,
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cluster list
                Clusters(clst: appState.clustersLists),
                // About you section
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                  const Header("About you"),
                  Paragraph(
                    "Your latitude: ${appState.lat}\nYour longitude: ${appState.long}",
                  ),
                  const SizedBox(height: 8),
                  Paragraph(
                      "Distance to the nearest cluster is ${appState.nearest_cluster.toStringAsFixed(2)}")
                ]),
                const Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.all(50.0),
                  child: _buildCompass(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // might need to accound for padding on iphones
    //var padding = MediaQuery.of(context).padding;
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data?.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        int ang = (direction.round());
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEBEBEB),
              ),
              child: Transform.rotate(
                angle: ((direction ?? 0) * (math.pi / 180) * -1),
                child: Image.asset('assets/compass.png'),
              ),
            ),
            Center(
              child: Text(
                "$ang",
                style: const TextStyle(
                  color: Color(0xFFEBEBEB),
                  fontSize: 45,
                ),
              ),
            ),
            /*
            Positioned(
              // center of the screen - half the width of the rectangle
              left: (width / 2) - ((width / 80) / 2),
              // height - width is the non compass vertical space, half of that
              top: (height - width) / 2,
              child: SizedBox(
                width: width / 80,
                height: width / 10,
                child: Container(
                  //color: HSLColor.fromAHSL(0.85, 0, 0, 0.05).toColor(),
                  color: const Color(0xBBEBEBEB),
                ),
              ),
            ),
            */
          ],
        );
      },
    );
  }
}
