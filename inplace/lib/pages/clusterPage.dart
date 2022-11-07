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
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Clusters(clst: appState.clustersLists),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
