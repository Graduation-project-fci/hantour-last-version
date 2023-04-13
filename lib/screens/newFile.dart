import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MapScreen2 extends StatefulWidget {
  const MapScreen2({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen2> {
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  List<LatLng> routeCoords = [];

  @override
  void initState() {
    super.initState();
  }

  void getRouteCoordinates() async {
    String startQuery = Uri.encodeComponent(startController.text);
    String endQuery = Uri.encodeComponent(endController.text);
    String url =
        "https://nominatim.openstreetmap.org/search?q=$startQuery&format=json";
    var response = await http.get(Uri.parse(url));
    var startLocation = jsonDecode(response.body);

    url = "https://nominatim.openstreetmap.org/search?q=$endQuery&format=json";
    response = await http.get(Uri.parse(url));
    var endLocation = jsonDecode(response.body);

    // Parse the response JSON to retrieve latitude and longitude coordinates
    var startLat =  startLocation[0]['lat'];
    var startLng = startLocation[0]['lon'];
    var endLat = endLocation[0]['lat'];
    var endLng = endLocation[0]['lon'];

    // Create a list of LatLng coordinates for the route
    routeCoords = [
      LatLng(double.parse(startLat), double.parse(startLng)),
      LatLng(double.parse(endLat), double.parse(endLng))
    ];

    // Force the widget to redraw to display the new route
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: routeCoords.isNotEmpty ? routeCoords.first : LatLng(0, 0),
          zoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(
                  points: routeCoords,
                  color:Colors.green,
                  strokeWidth: 5.0,
                )
              ]
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.6,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: startController,
              decoration: InputDecoration(
                labelText: "Start Address",
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: endController,
              decoration: InputDecoration(
                labelText: "End Address",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getRouteCoordinates();
              },
              child: Text("Get Route"),
            ),
          ],
        ),
      ),
    );
  }
}
