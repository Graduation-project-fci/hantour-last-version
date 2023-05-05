import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hantourgo/homePage.dart';
import 'package:hantourgo/screens/registerationScreens/selectPag.dart';

import '../button.dart';
import '../customloginButton/costumloginbutton.dart';
import '../homepage2.dart';
import '../socialLogin.dart';
import '../widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loginpage extends StatelessWidget {
  loginpage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //check is user is Driver or Passenger

  Future<bool> isUserDriver() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final driverQuerySnapshot = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(user.uid)
        .get();

    final passengerQuerySnapshot = await FirebaseFirestore.instance
        .collection('Riders')
        .where('passenger_id', isEqualTo: user.uid)
        .limit(1)
        .get();

    return driverQuerySnapshot.exists;
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

  /**************************************/
  // Future<void> _signIn(
  //     String user, String password, String screen, BuildContext context) async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: user,
  //       password: password,
  //     );

  //     print('User signed in: ${userCredential.user!.uid}');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }
  Future<void> _signIn(
      String user, String password, String screen, BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user,
        password: password,
      );

      if (userCredential.user != null) {
        bool role = await isUserDriver();
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

  /****************************************************** */
  final _formKey = GlobalKey<FormState>();
  final passkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  alignment: Alignment.center,
                  child: Image(
                      image: AssetImage('assets/images/hantour1.png'),
                      height: 150),
                ),
                // const SizedBox(height: 0),
                // Text('Login to your account',
                //   style: TextStyle(color: Colors.black,
                //    fontSize: 16,
                //    fontWeight: FontWeight.w500,),),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.only(top: 3, left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 7,
                        )
                      ],
                    ),
                    child: TextFormField(
                      validator: (value) {
                        final RegExp regex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          caseSensitive: false,
                          multiLine: false,
                        );
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!regex.hasMatch(value.trim())) {
                          return 'Please Enter Valid Email address';
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      decoration: InputDecoration(
                          hintText: 'username',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(0),
                          hintStyle: const TextStyle(
                            height: 1,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 55,
                  padding: const EdgeInsets.only(top: 3, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 7,
                      )
                    ],
                  ),
                  child: Form(
                    key: passkey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Too Short Password';
                        }
                        return null;
                      },
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                          hintText: 'password',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(0),
                          hintStyle: const TextStyle(
                            height: 1,
                          )),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Costumbuttonforlogin('login', 'Home', username!, password!,
                //     emailController, passwordController),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate() &&
                        passkey.currentState!.validate()) {
                      // Form is valid, do something here
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        bool role = await isUserDriver();
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
                        // Navigator.pushNamed(context, 'Home');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No user found for that email.'),
                            ),
                          );
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Wrong password provided for that user.'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 11, 7, 66),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ]),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                socialLogin(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => selectPag()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
