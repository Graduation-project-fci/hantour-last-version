import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hantourgo/homePage.dart';
import 'package:hantourgo/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class fpage extends StatefulWidget {
  @override
  State<fpage> createState() => _fpageState();
}

void requestMessge() async {
  FirebaseMessaging messaging = await FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permission granted');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('user granted Provisional persmission');
  } else {
    print('user denied Permission');
  }
}

class _fpageState extends State<fpage> {
  // const fpage({key? key}) : super(key: key);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestMessge();
    getTokwn();
  }

  String token =
      'duXws4e_TCOBwbigt-fP__:APA91bHwnvW-KLth9-LF-A7_x-1SEz31HBdQKaVNMaY0-zmiLRfpJDuolVBakDpwjIFoxZBNqQZxKAXi4AvfazTipMrkhuEnf4WU_BQGKBvMT0ga7Z9MCIB_LeVPSikJy3HhDooqx0ci';
  void getTokwn() async {
    await FirebaseMessaging.instance.getToken().then((token) => {
          setState(() {
            token = token;
            print('my toekn is ${token}');
            saveToken(token!);
          })
        });
  }

  void saveToken(String token) {
    FirebaseFirestore.instance
        .collection('UserTokens')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token});
  }

  void sendNotification(
    String token,
    String body,
    String title,
  ) async {
    try {
      final response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAGx_dmbw:APA91bGUVawdCUxK4PTR_Q2uiPkd4DBd7W3_UgVPPdCG1GseD3_taSDP0XT_AvFS_uqtDZ_ziAZ026CcR-tg8z6flGssRvkCZYx_NtSDtR5YPe7I2EhgZfga4N5uu2jBiXPsA86Buz_I'
              },
              body: jsonEncode(
                <String, dynamic>{
                  'priority': 'high',
                  'data': <String, dynamic>{
                    'click-action': 'FLUTTER_NOTIFICATION_CLICK',
                    'status': 'done',
                    'body': body,
                    'title': title
                  },
                  'notification': <String, dynamic>{
                    'title': title,
                    'body': body,
                    'android_channel_id': 'dbfood'
                  },
                  'to': token
                },
              ));
      if (response.statusCode != 200) {
        print(response.statusCode);
      }
      print('message tok ${token}: body:${body}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendNotification_2(
      String deviceToken, String title, String message) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAGx_dmbw:APA91bFNFxxwj2DZl2Y-UJjJD9lRdCPA9NX613syCXa9rMmVmQwvAemc-O9JL9Nxk1x0SC4ZZ4UldFFdXWmtb8VOy3fQ0hc6fZR2HQMl5B5eaoXRySD69tHZBKoGBn2qa8L3VLpTuK5u',
    };
    final body = jsonEncode({
      'notification': {
        'title': title, 'body': message,
        'icon': '@mipmap/logo2', // add the icon property here
        'sound': 'default',
        'priority': 'high',
      },
      'to': deviceToken,
    });
    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    print('message tok ${deviceToken}: body:${message}');
    if (response.statusCode != 200) {
      throw Exception('Failed to send notification.');
    }
  }

  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        print(user.uid);
        sendNotification(token, 'body', 'title');
        sendNotification_2(token, 'title', 'message');
        // user is signed in
        // Get.to(HomePage());
        Get.to(loginpage());
      } else {
        // user is not signed in
        Get.to(loginpage());
      }
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 11, 7, 66),
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo1.png'),
          height: 600,
        ),
      ),
    );
  }
}
