import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class ClustersList {
  ClustersList(
      {required this.lat, required this.lng, required this.avg_radius});
  final String lat;
  final String lng;
  final String avg_radius;
}
