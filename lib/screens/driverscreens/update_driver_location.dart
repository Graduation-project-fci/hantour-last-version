import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class Database {
  FirebaseDatabase database = FirebaseDatabase.instance;

  updateDriverLocation(String lat, String long, String email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("drivers/${email}");
    await ref.set({"latitude": lat, "longitude": long});
  }

  trackDriverLocation(String email) async {
    String lat = "";
    String long = "";
    Position position = await Geolocator.getCurrentPosition();
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      lat = position!.latitude.toString();
      long=position!.longitude.toString();
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
      updateDriverLocation(lat, long, email);
    });
  }
}
