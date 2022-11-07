import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/clustersList.dart';
import 'package:inplace/widgets/widgets.dart';

class Clusters extends StatefulWidget {
  const Clusters({
    super.key,
    required this.clst,
  });
  final List<ClustersList> clst;

  @override
  State<Clusters> createState() => _ClustersState();
}

class _ClustersState extends State<Clusters> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ClustersState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (widget.clst.isEmpty) const Text('List is empty'),
        for (var clu in widget.clst)
          Paragraph(
            'Latitude: ${clu.lat},\nLongitude: ${clu.lng},\nAverage Radius: ${clu.avg_radius}',
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
