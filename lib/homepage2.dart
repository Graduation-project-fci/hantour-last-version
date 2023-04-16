import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:hantourgo/constants/constantsize.dart';
import 'package:hantourgo/profile_pages/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';


class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Future<void> updateLocation(Function(LocationData) callback) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      callback(currentLocation);
    });
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
  var CurrentLocation=LatLng(0, 0);

  final _searchController_source = TextEditingController();
  final _searchController_destination = TextEditingController();
    var source_coordinates=LatLng(0, 0);
   var destination_coordinates=LatLng(0, 0);
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateLocation((LocationData currentLocation) {
      // Use the current location here
      CurrentLocation=LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
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
                        backgroundImage:
                            image != null // add null check operator
                                ? FileImage(
                                    image!) // add non-null assertion operator
                                : null,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(
                        'Mostafa M Malik',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(
                        'mostafammalik751@gmail.com',
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
                children: const [
                  Icon(
                    Icons.car_crash,
                    color: Colors.blue,
                  ),
                  Text(
                    'Orders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
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
                    'Payment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'viewdriver');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Text(
                      'Favorite Drivers',
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
            )
          ],
        ),
      ), // drawer(),
      body: Center(
          child: Stack(
        alignment: Alignment.bottomLeft,
        children: [


          FlutterMap(
            options: MapOptions(
              zoom: 14.0,
              maxZoom: 19.0,
              center: CurrentLocation,



            ),
            children: [
              TileLayer(
                urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',

              ),

                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      //LatLng(25.696751832973945, 32.645047861913596),LatLng(25.6944702171113, 32.64794464757829)


                      (source_coordinates!=null && destination_coordinates!=null)? Polyline( points: [source_coordinates,destination_coordinates],
                        color:Colors.green,strokeWidth: 4.0,
                  ):Polyline( points: [LatLng(0, 0),LatLng(0, 0)],
                        color:Colors.green,strokeWidth: 4.0,
                      )


                    ],
                  ),

               MarkerLayer(
                markers: [
                  Marker(point:LatLng(25.696838842882965, 32.644554335467014,),
                  width:80,
                  height: 80, builder: (context)=>Icon(Icons.gps_fixed),

                  ),


                ],
              )
            ],
          ),

          // /********************************************** */
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Padding(
                  //   padding:
                  //   const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                  //   child:
                  //       FloatingActionButton(
                  //         backgroundColor: Color.fromARGB(255, 6, 42, 70),
                  //         child: Icon(Icons.share_sharp),
                  //         onPressed: () {},
                  //       ),
                  //
                  //
                  // ),
// SizedBox(
//
//
//     height: MediaQuery.of(context).size.height*0.25) ,
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 6, 42, 70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 90,
                              height: 70,
                              child: Image.asset(
                                'assets/images/1.jpg',
                                width: 90,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 90,
                              height: 70,
                              child: Image.asset('assets/images/gps.png'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle_outlined,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 9,
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    controller: _searchController_source,
                                    decoration: const InputDecoration(
                                      focusColor: Colors.red,
                                      hintText: 'Search for a place',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    if (pattern.isEmpty) {
                                      return [];
                                    }

                                    String url =
                                        'https://nominatim.openstreetmap.org/search?q=$pattern&format=json&limit=20';
                                    http.Response response =
                                        await http.get(Uri.parse(url));
                                    List<dynamic> data =
                                        json.decode(response.body);

                                    return data.map((item) {
                                      return item['display_name'];
                                    }).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      textColor: Colors.white,
                                      tileColor: const Color.fromARGB(255, 6, 42, 70),
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) async {
                                    String url =
                                        'https://nominatim.openstreetmap.org/search?q=$suggestion&format=json&limit=1';
                                    http.Response response =
                                        await http.get(Uri.parse(url));
                                    List<dynamic> data =
                                        json.decode(response.body);

                                    double lat = double.parse(data[0]['lat']);
                                    double lng = double.parse(data[0]['lon']);
                                    _searchController_source.text = suggestion;
                                    print(
                                        'Selected place: $suggestion ($lat, $lng)');
                                    setState(() {
                                      source_coordinates=LatLng(lat, lng);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle_outlined,
                                color: Colors.grey,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 3),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 7,
                                  child: TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      style: const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: _searchController_destination,
                                      decoration: const InputDecoration(
                                        fillColor: Colors.red,
                                        focusColor: Colors.red,
                                        hintText: 'Search for a place',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      if (pattern.isEmpty) {
                                        return [];
                                      }

                                      String url =
                                          'https://nominatim.openstreetmap.org/search?q=$pattern&format=json&limit=20';
                                      http.Response response =
                                          await http.get(Uri.parse(url));
                                      List<dynamic> data =
                                          json.decode(response.body);

                                      return data.map((item) {
                                        return item['display_name'];
                                      }).toList();
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        textColor: Colors.white,
                                        tileColor:
                                            Color.fromARGB(255, 6, 42, 70),
                                        title: Text(suggestion),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) async {
                                      String url =
                                          'https://nominatim.openstreetmap.org/search?q=$suggestion&format=json&limit=1';
                                      http.Response response =
                                          await http.get(Uri.parse(url));
                                      List<dynamic> data =
                                          json.decode(response.body);

                                      double lat = double.parse(data[0]['lat']);
                                      double lng = double.parse(data[0]['lon']);
                                      _searchController_destination.text =
                                          suggestion;
                                      print(
                                          'Selected place: $suggestion ($lat, $lng)');
                                      setState(() {
                                        destination_coordinates=LatLng(lat, lng);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.grey,
                            ),
                            Container(
                              // padding: EdgeInsets.all(),
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width - 80,
                              height: 40,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'Offer your Fare',
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                    hintStyle: TextStyle(
                                        height: 1, color: Colors.grey)),
                              ),
                            ),
                          ],
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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                    )
                                  ]),
                              child: const Text('Call Driver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        ),
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
