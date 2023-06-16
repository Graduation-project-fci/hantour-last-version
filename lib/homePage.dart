import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';


import 'package:hantourgo/profile_pages/user_profile.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcom Back',
        ),
        backgroundColor: Color.fromARGB(255, 11, 7, 66),
      ),
      drawer: Drawer(
        // backgroundColor: Colors.red,

        surfaceTintColor: Color.fromARGB(255, 94, 114, 235),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  color: Color.fromARGB(255, 94, 114, 235),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 30),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 6, 42, 70),
                        radius: 80,
                        backgroundImage:
                            image != null // add null check operator
                                ? FileImage(
                                    image!) // add non-null assertion operator
                                : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(
                        'Mostafa M Malik',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
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
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  children: [
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
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
        children: [
          // GoogleMap(
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(37.7749, -122.4194),
          //     zoom: 12,
          //   ),
          // ),
          // GoogleMap(
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(37.77483, -122.41942),
          //     zoom: 12,
          //   ),
          //   polylines: {
          //     Polyline(
          //       polylineId: PolylineId('route1'),
          //       color: Colors.blue,
          //       width: 5,
          //       points: [
          //         LatLng(37.77483, -122.41942), // source
          //         LatLng(37.7749, -122.41815), // intermediate point
          //         LatLng(37.77493, -122.41793), // intermediate point
          //         LatLng(37.77493, -122.41793), // destination
          //       ],
          //     ),
          //   },
          // ),

          // /********************************************** */
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // FloatingActionButton(
                    //   backgroundColor: Color.fromARGB(255, 6, 42, 70),
                    //   child: Icon(
                    //     Icons.menu,
                    //     color: Color.fromARGB(255, 237, 240, 241),
                    //   ),
                    //   onPressed: () {},
                    // ),
                    FloatingActionButton(
                      backgroundColor: Color.fromARGB(255, 6, 42, 70),
                      child: Icon(Icons.share_sharp),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchController,
                  decoration: InputDecoration(
                    focusColor: Colors.red,
                    hintText: 'Search for a place',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) {
                    return [];
                  }

                  String url =
                      'https://nominatim.openstreetmap.org/search?q=$pattern&format=json&limit=10';
                  http.Response response = await http.get(Uri.parse(url));
                  List<dynamic> data = json.decode(response.body);

                  return data.map((item) {
                    return item['display_name'];
                  }).toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  String url =
                      'https://nominatim.openstreetmap.org/search?q=$suggestion&format=json&limit=1';
                  http.Response response = await http.get(Uri.parse(url));
                  List<dynamic> data = json.decode(response.body);

                  double lat = double.parse(data[0]['lat']);
                  double lng = double.parse(data[0]['lon']);

                  print('Selected place: $suggestion ($lat, $lng)');
                },
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          width: 90,
                          height: 70,
                        ),
                        Container(
                          margin: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          width: 90,
                          height: 70,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: Colors.grey,
                          ),
                          Container(
                            // padding: EdgeInsets.all(),
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width - 80,
                            height: 40,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: 'Destination',
                                  border: UnderlineInputBorder(),
                                  contentPadding: const EdgeInsets.all(0),
                                  hintStyle: const TextStyle(
                                      height: 1, color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Colors.grey,
                        ),
                        Container(
                          // padding: EdgeInsets.all(),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width - 80,
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Offer your Fare',
                                border: UnderlineInputBorder(),
                                contentPadding: const EdgeInsets.all(0),
                                hintStyle: const TextStyle(
                                    height: 1, color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.comment,
                          color: Colors.grey,
                        ),
                        Container(
                          // padding: EdgeInsets.all(),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          width: MediaQuery.of(context).size.width - 80,
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Write comment or notation to Driver',
                                border: UnderlineInputBorder(),
                                contentPadding: const EdgeInsets.all(0),
                                hintStyle: const TextStyle(
                                    height: 1, color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 94, 114, 235),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                              ]),
                          child: Text('Call Driver',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 6, 42, 70),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
