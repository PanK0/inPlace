// THIS WIDGET IS UNUSED

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late GoogleMapController mapController;
const LatLng _center = LatLng(41.890058429450804, 12.492756611335453);
void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

Widget mapSection = Container(
  padding: const EdgeInsets.all(16),
  child: const SizedBox(
    height: 300,
    child: GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
    ),
  ),
);
