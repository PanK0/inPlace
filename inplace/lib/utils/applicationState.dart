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

  /* 
  END GPS Stuff
  */

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

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
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) async {
          _guestBookMessages = [];
          await getGPSCoordinates();
          for (final document in snapshot.docs) {
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
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
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