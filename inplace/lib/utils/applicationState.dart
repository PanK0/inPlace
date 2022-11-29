import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../firebase_options.dart';
import 'guestbookMessage.dart';

import 'clustersList.dart';
import '../services/clustering_server_api.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  /* 
    START GPS Stuff
  */
  double lat = 0, long = 0;
  double fixed_distance = 0.01; // in terms of coordinates, 0.01 is equal to 1km

  Future<void> getGPSCoordinates() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      print("GPS service is enabled");
    } else {
      print("GPS service is disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
      } else {
        print("GPS Location service is granted");
      }
    } else {
      print("GPS Location permission granted.");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    long = position.longitude;
    lat = position.latitude;
  }

  // Function to check wether a pair of coordinate is in a specific range
  // since we have a range of 2*fixed_distance and fixed_distance = 0.01 and 0.01 is equal to 1km,
  // here are loaded all messages in an area of 2km^2 form the user.
  bool checkCoords(GeoPoint geoPoint) {
    double mlat = geoPoint.latitude;
    double mlon = geoPoint.longitude;

    if (mlat > lat - fixed_distance &&
        mlat < lat + fixed_distance &&
        mlon > long - fixed_distance &&
        mlon < long + fixed_distance) {
      return true;
    } else {
      return false;
    }
  }

  // Function to calculate the distance between two points A and B Earth.
  // Result is expressed in KM
  double get_distance(double lat_a, double lng_a, double lat_b, double lng_b) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat_b - lat_a) * p) / 2 +
        c(lat_a * p) * c(lat_b * p) * (1 - c((lng_b - lng_a) * p)) / 2;
    return (12742 * asin(sqrt(a)));
  }

  // Function to calculate the nearest cluster to point A
  double get_nearest_cluster(
      double lat_a, double lng_a, List<ClustersList> clusters) {
    var min_distance = 12742.0;

    for (int i = 0; i < clusters.length; i++) {
      var dist = get_distance(lat_a, lng_a, double.parse(clusters[i].lat),
          double.parse(clusters[i].lng));
      if (dist < min_distance) {
        min_distance = dist;
      }
    }
    return min_distance;
  }

  /* 
  END GPS Stuff
  */

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // To add messages taken from the database to the guestbook
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  // To add clusters taken from the database
  StreamSubscription<QuerySnapshot>? _clustersSubscription;
  List<ClustersList> _clustersLists = [];
  List<ClustersList> get clustersLists => _clustersLists;
  String banana = '0';
  double nearest_cluster = -1.0;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    /* REFS @ https://firebase.google.com/codelabs/firebase-get-to-know-flutter#6
    This section is important, as here is where you construct a query over the guestbook collection, 
    and handle subscribing and unsubscribing to this collection. You listen to the stream, 
    where you reconstruct a local cache of the messages in the guestbook collection, 
    and also store a reference to this subscription so you can unsubscribe from it later.
    */
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        /*
          Retrieve the clusters
        */
        /*
        _clustersSubscription = FirebaseFirestore.instance
            .collection('clusters')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snaps) async {
          _clustersLists = [];
          for (final document in snaps.docs) {
            var cl = ClustersList(
                lat: (document.data()['geotag'].latitude).toString(),
                lng: (document.data()['geotag'].longitude).toString(),
                avg_radius: (document.data()['avg_radius']).toString());
            //banana = document.data()['avg_radius'].toString();
            _clustersLists.add(cl);
          }
          notifyListeners();
        });
        */
        /*
          Retrieve the messages
        */
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) async {
          _guestBookMessages = [];
          await getGPSCoordinates();
          for (final document in snapshot.docs) {
            // Here we only show the messages in a fixed range of distance
            bool pass = checkCoords(document.data()['geotag']);
            if (pass) {
              _guestBookMessages.add(
                GuestBookMessage(
                  name: document.data()['name'] as String,
                  message: document.data()['text'] as String,
                ),
              );
            }
          }

          /*
            Retrieve the clusters
          */
          _clustersLists = await getClustersFromDB();
          notifyListeners();

          nearest_cluster = get_nearest_cluster(lat, long, _clustersLists);
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _clustersLists = [];
        _clustersSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    if (lat == 0 || long == 0) {
      await getGPSCoordinates();
    }

    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'geotag': GeoPoint(lat,
          long), // Save a GeoPoint. To access coordinates call i.e. geopoint.latitude, geopoint.longitude
    });
  }
}
