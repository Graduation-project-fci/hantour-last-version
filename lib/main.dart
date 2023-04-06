import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hantourgo/fpage.dart';
import 'package:hantourgo/googleMap/googlemap.dart';
import 'package:hantourgo/homePage.dart';
import 'package:hantourgo/reports/listoftickets.dart';
import 'package:hantourgo/screens/driverscreens/rating.dart';
import 'package:hantourgo/screens/loginPage%D9%90Amir.dart';
import 'package:hantourgo/screens/loginpage.dart';
import 'package:hantourgo/screens/pasRegister.dart';
import 'package:hantourgo/screens/registerationScreens/basic_info.dart';
import 'package:hantourgo/screens/registerationScreens/certificate_vehicle.dart';
import 'package:hantourgo/screens/registerationScreens/criminal_record.dart';
import 'package:hantourgo/screens/registerationScreens/driverLicense.dart';
import 'package:hantourgo/screens/registerationScreens/driver_register.dart';
import 'package:hantourgo/screens/registerationScreens/nationalID.dart';
import 'package:hantourgo/screens/registerationScreens/selectPag.dart';
import 'package:hantourgo/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: rating(),
      routes: {
        "login": (context) => loginpage(),
        // 'passSignUp': (context) => pasRegister(),
        'signup': (context) => signupscreen(),
        'Home': (context) => HomePage(),
        'tickethistory': (context) => reportOfTickets(),

        'basicinfo': (context) => BasicInfo(),
        'certificate': (context) => certificate_vehicle(),
        'criminal': (context) => criminal_record(),
        'driverregister': (context) => driver_register(),
        'driverlicense': (context) => driverLicense(),
        'select': (context) => selectPag(),
        'id': (context) => nationalID(),
        'rating': (context) => rating()
      },
    );
  }
}
