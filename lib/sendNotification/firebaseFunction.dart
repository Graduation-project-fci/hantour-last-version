import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hantourgo/homepage2.dart';

class firebaseFunctions {
  Future<void> getDeviceToken(String token) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    // Request permission to receive notifications (iOS only)
    await firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );

    // Get the device token
    token = (await firebaseMessaging.getToken())!;
  }

  Future<bool> isUserDriver(String email) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Drivers');

    final QuerySnapshot snapshot =
        await collection.where('email', isEqualTo: email).limit(1).get();

    return snapshot.docs.isNotEmpty;
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      return googleUser;
    } catch (error) {
      print('Failed to sign in with Google: $error');
      return null;
    }
  }
  /********************************************** */

// method for check username and password
  Future<int> countRecords(String username, String password) async {
    final database = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot = (await database
        .orderByChild('username')
        .equalTo(username)
        .once()) as DataSnapshot;
    Map<dynamic, dynamic>? data = snapshot.value as Map?;
    int count = 0;
    if (data != null) {
      data.forEach((key, value) {
        if (value['password'] == password) {
          count++;
        }
      });
    }

    // Return the number of records
    return count;
  }

  Future<void> _signIn(
      String user, String password, String screen, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user,
        password: password,
      );

      if (userCredential.user != null) {
        bool role = await isUserDriver(user);
        if (role) {
          Navigator.pushNamed(context, 'Driverhome');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage2(),
            ),
          );
        }
      }

      print('User signed in: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
