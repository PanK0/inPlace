import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Geoloc extends StatefulWidget {
  const Geoloc({super.key});

  String get long => long;
  String get lat => lat;
  @override
  State<Geoloc> createState() => _GeolocState();
}

class _GeolocState extends State<Geoloc> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";

  // Coordinates used for the MAP
  static const LatLng default_location = LatLng(0, 0);
  late LatLng center =
      default_location; //LatLng(41.890058429450804, 12.492756611335453); // Colosseum, Rome coordinates

  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    center = LatLng(position.latitude, position.longitude);

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();
      center = LatLng(position.latitude, position.longitude);

      setState(() {
        //refresh UI on update
      });
    });
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Widget showing the map in the current location or a "preview" section
  @override
  Widget build(BuildContext context) {
    if (center != default_location) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 11.0,
            ),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 30,
        child: Text("LatLng: $center", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

/*
  GPS WIDGET @ https://www.fluttercampus.com/guide/212/get-gps-location/

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
         appBar: AppBar(
            title: Text("Get GPS Location"),
            backgroundColor: Colors.redAccent
         ),
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(50),
             child: Column(
                children: [ 

                     Text(servicestatus? "GPS is Enabled": "GPS is disabled."),
                     Text(haspermission? "GPS is Enabled": "GPS is disabled."),
                     
                     Text("Longitude: $long", style:TextStyle(fontSize: 20)),
                     Text("Latitude: $lat", style: TextStyle(fontSize: 20),)

                ]
              )
          )
    );
  } 
*/

