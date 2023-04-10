import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController _marker = MapController();
  late LatLng _currentLocation = LatLng(0, 0);
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );
        _addMarkerAtUserLocation();
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }


  void _addMarkerAtUserLocation() {
    // Create a marker at the user's location
    final marker = Marker(
      point: _currentLocation,
      builder: (ctx) => Icon(Icons.location_on,color: Colors.red,size: 40,),
    );

    // Update the FlutterMap widget with the new marker
    setState(() {
      _markers.clear();
      _markers.add(marker);
      _marker.move(_currentLocation, 16);
    });
  }

  bool _isOnline = false;
  String status = "Offline";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 128),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(_isOnline ? 'Online' : 'Offline', style: TextStyle(fontSize: 16)),
            SizedBox(width: 10),
            Switch(
              value: _isOnline,
              onChanged: (value) {
                setState(() {
                  _isOnline = value;
                  status = value ? 'Online' : 'Offline';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You are $status now'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body:Stack(children: [
        FlutterMap(
          options: MapOptions(
            zoom: 16.0,
            maxZoom: 19.0,

          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            // PolygonLayer(
            //   polygonCulling: false,
            //   polygons: [
            //     Polygon(
            //       points: [LatLng(25.696780836284027, 32.64479036985451), LatLng(25.695146972139565, 32.642258364606846),LatLng(25.69497294978535, 32.63913627339045),],
            //       color: Colors.red,
            //       //borderStrokeWidth: 10.0,
            //       isDotted: true,
            //       label: 'route',
            //       labelStyle: const TextStyle(fontSize: 15.0)
            //     ),
            //   ],
            // ),

            PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                    points: [LatLng(25.696780836284027, 32.64479036985451), LatLng(25.695146972139565, 32.642258364606846),LatLng(25.69497294978535, 32.63913627339045),],
                    color:Colors.green,
                    strokeWidth: 5.0,


                  )
                ]

            )


          ],
        ),
Column(children: [
  FloatingActionButton(onPressed: (){} ) ,
  Container(width :100  ,height: 50 , child: TextFormField())

],)
      ],)


    );
  }

}


