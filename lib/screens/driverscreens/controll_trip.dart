// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:hantourgo/sendNotification/api.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';

// import 'package:hantourgo/constants/constantsize.dart';
// import 'package:hantourgo/profile_pages/user_profile.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hantourgo/googleMap/calculateDistance.dart';
// import 'package:geoflutterfire2/geoflutterfire2.dart';
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geoflutterfire2/geoflutterfire2.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import '../driverscreens/update_driver_location.dart';

// class Trip_controll extends StatefulWidget {
//   final String id;
//    String distance ="";

//    Trip_controll({super.key, required this.id});

//   @override
//   State<Trip_controll> createState() => _Trip_controllState();
// }

// class _Trip_controllState extends State<Trip_controll> {
//   Database _database = new Database();
//   Map<String, dynamic> request = {};
//   final UserEmail = FirebaseAuth.instance.currentUser!.email;
//   final MapController _mapController_ = MapController();
//   readrequest() async {
//     if (widget.id != '') {
//       request = (await readRequest('${widget.id}')) ?? {};
//       print(request['sendertoken']);
//     }
//   }
//   Future<Map<String, dynamic>?> readRequest(String requestId) async {
//     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//         .instance
//         .collection('Requests')
//         .doc(requestId)
//         .get();
//     return snapshot.data();
//   }

//   void _makePhoneCall(String phone) async {
//     final phoneNumber = 'tel:+2$phone';
//     if (await canLaunch(phoneNumber)) {
//       await launch(phoneNumber);
//     } else {
//       throw 'Could not launch $phoneNumber';
//     }
//   }

//   final Marker _marker_ = Marker(
//     point: LatLng(0, 0),
//     width: 50,
//     height: 50,
//     builder: (context) => const Icon(
//       Icons.location_on,
//       size: 50,
//       color: Colors.red,
//     ),
//   );
//   @override
//    void initState()   {
//     // TODO: implement initState
//     super.initState();
//     String lat = "";
//     String long = "";
//     Position position =   Geolocator.getCurrentPosition();
//     final LocationSettings locationSettings = const LocationSettings(
//       distanceFilter: 100,
//     );
//     StreamSubscription<Position> positionStream =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position? position) {
//       lat = position!.latitude.toString();
//       long = position!.longitude.toString();
//       print(position == null
//           ? 'Unknown'
//           : '${position.latitude.toString()}, ${position.longitude.toString()}');
//       setState(() {
//         lat = position.latitude.toString();
//         long = position.longitude.toString();
//       });
//       _database.updateDriverLocation(lat, long, UserEmail!);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//           child: Stack(
//         alignment: Alignment.bottomLeft,
//         children: [
//           FlutterMap(
//               mapController: _mapController_,
//               options: MapOptions(
//                   zoom: 11.0,
//                   maxZoom: 19.0,
//                   center: _marker_.point //_marker.point,
//                   ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.example.app',
//                 ),
//                 MarkerLayer(),
//               ]),

//           // /********************************************** */
//           Visibility(
//             visible: true,
//             child: SingleChildScrollView(
//               child: Container(
//                 margin: EdgeInsets.zero,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2.1,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 6, 42, 70),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             SingleChildScrollView(
//                               child: Container(
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                           alignment: Alignment.topLeft,
//                                           margin:
//                                               const EdgeInsets.only(right: 5),
//                                           // width: 50,
//                                           // height: 50,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               CircleAvatar(
//                                                 radius: 40,
//                                                 backgroundColor:
//                                                     const Color.fromARGB(
//                                                         255, 27, 79, 158),
//                                                 backgroundImage: NetworkImage(
//                                                     '${request['image']}!' !=
//                                                             null
//                                                         ? '${request['image']}'
//                                                         : 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80'),
//                                               ),
//                                               Text(
//                                                 "${request['name']}",
//                                                 style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 25,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           )),
//                                       Container(
//                                           child: Column(
//                                         children: [
//                                           Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               children: [
//                                                 Text(
//                                                   "${request['source_location']}",
//                                                   style: const TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ]),
//                                           const SizedBox(
//                                             child: Icon(Icons.arrow_downward),
//                                           ),
//                                           Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               children: [
//                                                 Text(
//                                                   "${request['destination_location']}",
//                                                   style: const TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ]),
//                                         ],
//                                       )),
//                                       Container(
//                                         child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Text(
//                                                 "علي بعد  ${widget.distance} متر",
//                                                 style: const TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text(
//                                                   "السعر المعروض: ${request['price']}",
//                                                   style: const TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ]),
//                                       ),
//                                       Container(
//                                           margin: const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           decoration: BoxDecoration(
//                                               color: const Color.fromARGB(
//                                                   255, 6, 42, 70),
//                                               borderRadius:
//                                                   BorderRadius.circular(15)),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text('${request['phone_number']}',
//                                                   style: const TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold)),
//                                               IconButton(
//                                                 onPressed: () {
//                                                   print(
//                                                       request['phone_number']);
//                                                   _makePhoneCall(
//                                                       request['phone_number']);
//                                                 },
//                                                 icon: const Icon(
//                                                   Icons.phone,
//                                                   color: Colors.green,
//                                                 ),
//                                               )
//                                             ],
//                                           ))
//                                     ],
//                                   ),
//                                 ),
//                                 margin: const EdgeInsets.all(5),
//                                 width: MediaQuery.of(context).size.width,
//                                 height: MediaQuery.of(context).size.height / 3,
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(40),
//                                       topRight: Radius.circular(10),
//                                       bottomLeft: Radius.circular(10),
//                                       bottomRight: Radius.circular(10)),
//                                   color: Color.fromARGB(255, 128, 154, 192),
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.all(5),
//                                 alignment: Alignment.center,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     borderRadius: BorderRadius.circular(6),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         blurRadius: 10,
//                                       )
//                                     ]),
//                                 child: const Text('Start Trip',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600,
//                                     )),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }
