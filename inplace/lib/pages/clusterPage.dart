import 'dart:math';

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
                  const Header("Nearest Cluster"),
                  Paragraph(
                      'Latitude: ${appState.nearest_lat}\nLongitude: ${appState.nearest_lng}'),
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
                const Header("Jack's Compass"),
                Container(
                  margin: const EdgeInsets.all(50.0),
                  child: _buildCompass(context, appState.theta),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
    We want the compass to point from a pair of coords (your position) to another pair (the nearest cluster)
    According to 
    @ https://gis.stackexchange.com/questions/228656/finding-compass-direction-between-two-distant-gps-points
    AND
    @ http://www.movable-type.co.uk/scripts/latlong.html
    the formula to use to find the angle of the compass is: 
    θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
    where
    φ1,λ1 is the start point, φ2,λ2 the end point (Δλ is the difference in longitude)
  */

  Widget _buildCompass(BuildContext context, theta) {
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

        // const brng = (θ*180/Math.PI + 360) % 360; // in degrees
        double brng = (theta * 180 / math.pi + 360) % 360;
        brng = double.parse(brng.toStringAsFixed(2));
        theta = double.parse(theta.toStringAsFixed(2));
        double tot = (direction - brng) % 360;
        tot = double.parse(tot.toStringAsFixed(2));

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
                angle: ((direction) * (math.pi / 180) * -1),
                child: Image.asset('assets/compass_background.png'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: ((direction - brng) * (math.pi / 180) * -1),
                child: Image.asset('assets/compass_needle.png'),
              ),
            ),
            Center(
              heightFactor: height / 100,
              child: Text(
                "$tot°",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 255, 0),
                  fontSize: 30,
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
