import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:hantourgo/sendNotification/SenderActor.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hantourgo/firebase_Services/authentication.dart';
import 'package:hantourgo/sendNotification/api.dart';
import 'package:hantourgo/sendNotification/firebaseFunction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
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

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  String device_token = "";
  firebaseFunctions fire = firebaseFunctions();
  int clicktab = 1;
  late Marker _marker = Marker(
    point: LatLng(0, 0),
    width: 50,
    height: 50,
    builder: (context) => FlutterLogo(),
  );

  final MapController _mapController = MapController();
  CollectionReference requests =
      FirebaseFirestore.instance.collection('Requests');

  Future<List<String>> getDriverIds(String collectionPath) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    final snapshot = await collectionRef.get();
    final ids = snapshot.docs.map((doc) => doc.id).toList();
    return ids;
  }

  Future<List<dynamic>> getUserTokens(List<String> driverIds) async {
    final userTokensCollectionRef =
        FirebaseFirestore.instance.collection('UserTokens');
    final batchSize = 10;
    final chunks = [
      for (var i = 0; i < driverIds.length; i += batchSize)
        driverIds.sublist(i,
            i + batchSize > driverIds.length ? driverIds.length : i + batchSize)
    ];

    final userTokens = [];
    for (final chunk in chunks) {
      final userTokensQuerySnapshot = await userTokensCollectionRef
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      userTokens.addAll(
          userTokensQuerySnapshot.docs.map((doc) => doc.data()['token']));
    }

    return userTokens;
  }

  var distance = '0';

  String source_location = '';
  String destination_location = '';
  String price = '';
  Future<void> addPassengerRequest(
      GeoPoint sourceLocation, GeoPoint destinationLocation) async {
    setState(() {
      source_location = _searchController_source.text.trim();
      destination_location = _searchCont_destination.text.trim();
      price = _offer_controller.text.trim();
      // distance = calculateDistance(
      //     _currentPosition.latitude,
      //     _currentPosition.longitude,
      //     source_coordinates.latitude,
      //     source_coordinates.longitude);
    });
    final collectionRef = FirebaseFirestore.instance.collection('Requests');
    final geo = GeoFlutterFire();
    final sourceGeoPoint = geo.point(
        latitude: sourceLocation.latitude, longitude: sourceLocation.longitude);
    final destinationGeoPoint = geo.point(
        latitude: destinationLocation.latitude,
        longitude: destinationLocation.longitude);
    final userData = await getUserData();
    PersonalImageLink = userData.data()?['personal_image'] ??
        'https://crda.ap.gov.in/apcrdadocs/EMPLOYE%20PHOTOS/user.png';
    Phone_number = userData.data()?['phone'] ?? '';
// ...

// Download the image from Firebase Storage
    firebaseFunctions fire = firebaseFunctions();

    fire.getDeviceToken(device_token!);
    final data = {
      'rider_id': FirebaseAuth.instance.currentUser!.uid,
      'source_coordinates': sourceGeoPoint.data,
      'destination_coordinates': destinationGeoPoint.data,
      'payment_method': 'cash',
      'status': 'pending',
      'source_location': source_location,
      'destination_location': destination_location,
      'price': price,
      'image': PersonalImageLink,
      'phone_number': Phone_number,
      'name': Name,
      'sendertoken': device_token
    };

    await collectionRef.add(data);
    // final Drivers = await getDriverIds('basicInfo');

    final driverIds = await getDriverIds('Drivers');
    final userTokens = await getUserTokens(driverIds);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    late final driverQuerySnapshot;
    try {
      final user = FirebaseAuth.instance.currentUser;
      driverQuerySnapshot = await FirebaseFirestore.instance
          .collection('Riders')
          .doc(user!.uid)
          .get();
    } catch (exception) {
      print('Error fetching user data: $exception');
      // Handle the error accordingly (e.g., display an error message, retry, etc.)
      // You can also throw the exception or return an error value, depending on your requirements.
      // For simplicity, returning null is shown here as an example.
    }
    return driverQuerySnapshot;
  }

  String Email = '';
  String PersonalImageLink =
      'https://crda.ap.gov.in/apcrdadocs/EMPLOYE%20PHOTOS/user.png';
  String Name = 'UnKnown';
  String Phone_number = '';
  Future<void> fetchData() async {
    final userData = await getUserData();
    final data = userData.data();
    setState(() {
      if (data != null) {
        Email = data['email'] ?? '';
        print(Email);
        PersonalImageLink = data['personal_photo'] ??
            'https://crda.ap.gov.in/apcrdadocs/EMPLOYE%20PHOTOS/user.png';
        if (data['name'] != '') {
          Name = data['name'];
        } else {
          Name = "Unknown";
        }
        if (data['phone'] != '') {
          Phone_number = data['phone'];
        } else {
          Phone_number = "";
        }

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
  }

  var CurrentLocation = LatLng(0, 0);
  List<Marker> markers = [];

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
    // _getCurrentLocation();
    // fire.getDeviceToken(device_token);
    firebaseMessaging.getToken().then(
          (value) => device_token = value!,
        );

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
      });
    } else {
      print('Error reverse geocoding: ${response.statusCode}');
    }
  }

  String Distance = '';
  void handleMarkers() {
    while (markers.length > 2) {
      markers.removeAt(0);
    }

    String distance = calculateDistance(
      markers.first.point.latitude,
      markers.first.point.longitude,
      markers.last.point.latitude,
      markers.last.point.longitude,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Distance is ${distance}'),
      ),
    );
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
                    GestureDetector(
                      onTap: uploadImage,
                      child: Padding(
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
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  print('logout');
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, 'SplashScreen');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                    ),
                    Text(
                      'Log Out',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
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
              zoom: 15.0,
              maxZoom: 19.0,
              center: _marker.point,
              onTap: (tapPosition, latLng) {
                setState(() {
                  markers.add(
                    Marker(
                      point: latLng,
                      width: 50,
                      height: 50,
                      builder: (context) => Icon(
                        Icons.location_on,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  );
                  handleMarkers();

                  if (markers.length >= 2) {
                    source_coordinates = markers.first.point;
                    destination_coordinates = markers.last.point;
                    getAddressFromLatLng(
                      source_coordinates.latitude,
                      source_coordinates.longitude,
                    ).then((source) {
                      _searchController_source.text = source;
                    });
                    getAddressFromLatLng(
                      destination_coordinates.latitude,
                      destination_coordinates.longitude,
                    ).then((destination) {
                      _searchCont_destination.text = destination;
                    });
                  }
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolylineLayer(
                polylineCulling: false,
                polylines: markers.length >= 2
                    ? [
                        Polyline(
                          points: [source_coordinates, destination_coordinates],
                          color: Colors.green,
                          strokeWidth: 4.0,
                        )
                      ]
                    : [],
              ),
              MarkerLayer(
                markers: markers,
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
                            GestureDetector(
                              // onTap: _getCurrentLocation,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 90,
                                height: 70,
                                child: Image.asset('assets/images/gps.png'),
                              ),
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
                                      fillColor: Colors.red,
                                      focusColor: Colors.red,
                                      hintText:
                                          'Search for a place or Select from Map',
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
                                    if (response.statusCode == 200) {}
                                    List<dynamic> data =
                                        json.decode(response.body);

                                    return data.map((item) {
                                      return item['display_name'];
                                    }).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      textColor: Colors.white,
                                      tileColor: Color.fromARGB(255, 6, 42, 70),
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
                                      source_coordinates = LatLng(lat, lng);
                                      markers.add(
                                        Marker(
                                          point: source_coordinates,
                                          width: 50,
                                          height: 50,
                                          builder: (context) => Icon(
                                            Icons.location_on,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                        ),
                                      );

                                      handleMarkers();
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: _searchCont_destination,
                                      decoration: const InputDecoration(
                                        fillColor: Colors.red,
                                        focusColor: Colors.red,
                                        hintText:
                                            'Search for a place or Select from Map',
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

                                      if (data.isNotEmpty) {
                                        double lat =
                                            double.parse(data[0]['lat']);
                                        double lng =
                                            double.parse(data[0]['lon']);
                                        _searchCont_destination.text =
                                            suggestion;
                                        print(
                                            'Selected place: $suggestion ($lat, $lng)');
                                        setState(() {
                                          destination_coordinates =
                                              LatLng(lat, lng);
                                          markers.add(
                                            Marker(
                                              point: destination_coordinates,
                                              width: 50,
                                              height: 50,
                                              builder: (context) => Icon(
                                                Icons.location_on,
                                                size: 50,
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                          if (markers.length > 2) {
                                            markers.removeAt(1);
                                          }
                                        });
                                      } else {
                                        print(
                                            'No results found for suggestion: $suggestion');
                                      }
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width - 80,
                              height: 40,
                              child: TextFormField(
                                controller: _offer_controller,
                                keyboardType: TextInputType.number,
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: InkWell(
                            onTap: () async {
                              if (_searchController_source.text.isNotEmpty &&
                                  _searchCont_destination.text.isNotEmpty &&
                                  _offer_controller.text.isNotEmpty) {
                                addPassengerRequest(
                                    GeoPoint(source_coordinates.latitude,
                                        source_coordinates.longitude),
                                    GeoPoint(destination_coordinates.latitude,
                                        destination_coordinates.longitude));
                                // retrieveFCMToken();
                                List<String> usertokens = [];
                                usertokens =
                                    await fetchAllTokens('DriversTokens')
                                        as List<String>;
                                print(
                                    '=======================Tokens====================\n');
                                // print(usertokens);
                                print('\n\n');
                                print(device_token);
                                var api = API();
                                String? token =
                                    await firebaseMessaging.getToken();
                                // var sendertokrn =
                                //     api.sendAndRetrieveMessage_New(usertokens,
                                //         'i am happy', 'A7a', token!);
                                // print(
                                //     ' hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh +${sendertokrn}');
                                api.sendAndRetrieveMessage(usertokens, '$Name',
                                    'رحلة جديدة لا تفوتها واربح المزيد من المال');
                              } else {
                                print("No");
                              }

                              _searchCont_destination.text = '';
                              _searchController_source.text = '';
                              _offer_controller.text = '';
                              markers.removeRange(0, markers.length);
                              setState(() {
                                markers = [];
                              });
                              print(_searchController_source.text);
                              print(_searchCont_destination.text);
                            },
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
