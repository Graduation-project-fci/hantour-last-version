import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hantourgo/homePage.dart';

import '../button.dart';
import '../customloginButton/costumloginbutton.dart';
import '../socialLogin.dart';
import '../widgets.dart';

class loginpage extends StatelessWidget {
  loginpage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // late final String username = "mostafammalik751@gmail.com";
  // late final String password = "xxx";

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
        );
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
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: Image(
                      image: AssetImage('assets/images/hantour.png'),
                      height: 150),
                ),
                // const SizedBox(height: 0),
                // Text('Login to your account',
                //   style: TextStyle(color: Colors.black,
                //    fontSize: 16,
                //    fontWeight: FontWeight.w500,),),
                const SizedBox(height: 25),
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
                  child: TextFormField(
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
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
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

                const SizedBox(height: 25),

                // Costumbuttonforlogin('login', 'Home', username!, password!,
                //     emailController, passwordController),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'Home');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 128),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ]),
                    child: Text('Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                SizedBox(height: 25),
                button('Sign Up', 'select'),
                const SizedBox(height: 40),
                const socialLogin(),
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
              onTap: () async {
                final GoogleSignInAccount? googleUser =
                    await signInWithGoogle();
                if (googleUser != null) {
                  // The user has signed in successfully.
                  // You can now use their information to authenticate your app.
                }
              },
              child: Text(
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
