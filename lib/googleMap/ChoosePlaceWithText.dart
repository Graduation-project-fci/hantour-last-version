// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// Future<Map<String, dynamic>> getLatLng(String place) async {
//   final apiKey = '8f4a466fcee646e3ba7bfb658aa5aead';
//   final url =
//       'https://api.opencagedata.com/geocode/v1/json?q=$place&key=$apiKey';
//   final response = await http.get(Uri.parse(url));
//   final json = jsonDecode(response.body);
//   final geometry = json['results'][0]['geometry'];
//   return {'lat': geometry['lat'], 'lng': geometry['lng']};
// }

// class MapEx extends StatefulWidget {
//   const MapEx({Key? key}) : super(key: key);

//   @override
//   _MapExState createState() => _MapExState();
// }

// class _MapExState extends State<MapEx> {
//   late Future<Map<String, dynamic>> latLngFuture;
//   final place = 'Cairo';

//   @override
//   void initState() {
//     super.initState();
//     latLngFuture = getLatLng(place);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: latLngFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final latLng = snapshot.data!;
//             return GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(latLng['lat'], latLng['lng']),
//                 zoom: 12,
//               ),
//               markers: {
//                 Marker(
//                   markerId: MarkerId(place),
//                   position: LatLng(latLng['lat'], latLng['lng']),
//                 )
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('${snapshot.error}'));
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
