import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:hantourgo/constants/constantsize.dart';
import 'package:hantourgo/profile_pages/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hantourgo/googleMap/calculateDistance.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class driverHome extends StatefulWidget {
  const driverHome({super.key});

  @override
  State<driverHome> createState() => _HomePage2State();
}

class _HomePage2State extends State<driverHome> {
  late Marker _marker;

  final MapController _mapController = MapController();
  CollectionReference requests =
      FirebaseFirestore.instance.collection('Requests');
  Future<void> addPassengerRequest(
      GeoPoint sourceLocation, GeoPoint destinationLocation) async {
    final collectionRef = FirebaseFirestore.instance.collection('Request');

    final geo = GeoFlutterFire();
    final sourceGeoPoint = geo.point(
        latitude: sourceLocation.latitude, longitude: sourceLocation.longitude);
    final destinationGeoPoint = geo.point(
        latitude: destinationLocation.latitude,
        longitude: destinationLocation.longitude);

    final data = {
      'rider_id': FirebaseAuth.instance.currentUser!.uid,
      'source_coordinates': sourceGeoPoint.data,
      'destination_coordinates': destinationGeoPoint.data,
      'payment_method': 'cash',
      'status': 'Pending',
      'source_location': _searchController_source.text.trim(),
      'destination_location': _searchCont_destination.text.trim(),
      'price': _offer_controller.text.trim(),
      'image': PersonalImageLink,
      'name': Name,
    };

    await collectionRef.add(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final driverQuerySnapshot = await FirebaseFirestore.instance
        .collection('Riders')
        .doc(user!.uid)
        .get();
    return driverQuerySnapshot;
  }

  String Email = '';

  String PersonalImageLink = '';
  String Name = '';
  Future<void> fetchData() async {
    final userData = await getUserData();
    final data = userData.data();
    setState(() {
      if (data != null) {
        Email = data['email'] ?? '';

        PersonalImageLink = data['personal_photo'] ??
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/2048px-User_icon_2.svg.png';
        Name = data['name'] ?? '';
        print('Name: $Name');
      }
    });

    // do something with the data
  }

  double heightvar = 30;
  double _height = 300.0;
  final double _defaultHeight = 30.0;
  TextEditingController locationController = TextEditingController();
  TextEditingController distnationController = TextEditingController();
  File? image; // add ? for null safety
  // phoneSize psize = phoneSize();

  final imagepicker = ImagePicker();

  Future<void> uploadImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      print("No Image chosen yet"); // replace Text with print
    } else {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  void _makePhoneCall({String phone = '01030968534'}) async {
    final phoneNumber = 'tel:+2$phone';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  TextEditingController _offer_controller = TextEditingController();
  Future<void> _updateMarkerPosition() async {
    try {
      // retrieve the user's current location using geolocator
      Position position = await Geolocator.getCurrentPosition();
      // create a new marker object with the updated position
      Marker updatedMarker = Marker(
        point: LatLng(position.latitude, position.longitude),
        width: 50,
        height: 50,
        builder: (context) => FlutterLogo(),
      );
      // update the state of your widget tree with the new marker object
      setState(() {
        _marker = updatedMarker;

        (_searchController_source.text == "")
            ? _mapController.move(_marker.point, 15.0)
            : null;
      });
    } catch (e) {
      print('Error retrieving location: $e');
    }
    // call this function again after 5 seconds
    Future.delayed(Duration(seconds: 5), () => _updateMarkerPosition());
  }

  var CurrentLocation = LatLng(0, 0);
  List<Marker> _markers = [];

  final _searchController_source = TextEditingController();
  final _searchCont_destination = TextEditingController();
  var source_coordinates = LatLng(0, 0);
  var destination_coordinates = LatLng(0, 0);
  var center = LatLng(25.696838842882965, 32.644554335467014);
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    String apiUrl =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1";
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      String address = result["display_name"];
      return address;
    } else {
      return "Unable to retrieve address";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    print(Email);

    _marker = Marker(
      point: center,
      width: 50,
      height: 50,
      builder: (context) => FlutterLogo(),
    );
    source_coordinates = LatLng(0, 0);
    destination_coordinates = LatLng(0, 0);
    _updateMarkerPosition();
  }

  void _handleTap(LatLng latLng) async {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;

    String url =
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=jsonv2';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      String placeName = jsonResponse['display_name'];
      print(placeName);

      setState(() {
        _marker = Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(latitude, longitude),
          builder: (ctx) => Icon(
            Icons.location_on,
            size: 50,
            color: Colors.red,
          ),
        );
        _mapController.move(LatLng(latitude, longitude), 15.0);
      });
    } else {
      print('Error reverse geocoding: ${response.statusCode}');
    }
  }

  String Distance = '';
  void handleMarkers() {
    while (_markers.length > 2) {
      _markers.removeAt(0);
      Distance = calculateDistance(
          _markers.first.point.latitude,
          _markers.first.point.longitude,
          _markers.last.point.latitude,
          _markers.last.point.longitude);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Distance is ${Distance} '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      drawer: Drawer(
        surfaceTintColor: Colors.green,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  color: Colors.green,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 30),
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 6, 42, 70),
                        radius: 80,
                        backgroundImage: PersonalImageLink !=
                                '' // add null check operator
                            ? NetworkImage(
                                PersonalImageLink) // add non-null assertion operator
                            : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: (Name == '')
                          ? Text('')
                          : Text(
                              '${Name}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: (Email == '')
                          ? Text('')
                          : Text(
                              '${Email}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.car_crash,
                    color: Colors.blue,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'Orders');
                    },
                    child: Text(
                      'Orders',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'wallet');
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.yellow,
                    ),
                    Text(
                      'My Wallet',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.phone,
                    color: Colors.red,
                  ),
                  Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print('logout');
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.blue,
                    ),
                    Text(
                      'Log Out',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ), // drawer(),
      body: Center(
          child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                zoom: 11.0,
                maxZoom: 19.0,
                center: LatLng(20.2332, 23.432) //_marker.point,
                ),
          ),

          // /********************************************** */
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 6, 42, 70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(right: 10),
                                  // width: 50,
                                  // height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor:
                                            Color.fromARGB(255, 27, 79, 158),
                                        backgroundImage: image !=
                                                null // add null check operator
                                            ? FileImage(
                                                image!) // add non-null assertion operator
                                            : null,
                                      ),
                                      Text(
                                        "Mostafa Malik",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                              Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Source : Luxor City",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Distnation : Awamya",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ),
                              Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "about 15 meter",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text("Price offered: \$ 15",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("01030968534",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                          onPressed: _makePhoneCall,
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.green,
                                          ))
                                    ],
                                  ))
                            ],
                          ),
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Color.fromARGB(255, 128, 154, 192),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                              ]),
                          child: const Text('Accept Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.comment,
                        //       color: Colors.grey,
                        //     ),
                        //     Container(
                        //       // padding: EdgeInsets.all(),
                        //       margin: EdgeInsets.symmetric(
                        //           horizontal: 20, vertical: 10),
                        //       width: MediaQuery.of(context).size.width - 80,
                        //       height: 40,
                        //       child: TextFormField(
                        //         keyboardType: TextInputType.emailAddress,
                        //         obscureText: false,
                        //         decoration: InputDecoration(
                        //             fillColor: Colors.white,
                        //             hintText: 'Write comment or notation to Driver',
                        //             border: UnderlineInputBorder(),
                        //             contentPadding: const EdgeInsets.all(0),
                        //             hintStyle: const TextStyle(
                        //                 height: 1, color: Colors.grey)),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
