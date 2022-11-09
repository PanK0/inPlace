import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/authentication.dart';
import '../widgets/appbar.dart';
import '../widgets/clusters.dart';
import '../utils/applicationState.dart';
import '../widgets/widgets.dart';

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
