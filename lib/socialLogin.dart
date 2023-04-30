import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homepage2.dart';

class socialLogin extends StatelessWidget {
   socialLogin({Key? key}) : super(key: key);
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final GoogleSignIn _googleSignIn = GoogleSignIn();

   Future<UserCredential> signInWithGoogle() async {
     // Trigger the Google authentication flow
     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

     // Obtain the auth details from the Google sign-in
     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

     // Create a new credential
     final OAuthCredential credential = GoogleAuthProvider.credential(
       accessToken: googleAuth.accessToken,
       idToken: googleAuth.idToken,
     );

     // Sign in with the credential
     return await _auth.signInWithCredential(credential);
   }
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            '- Or Sign In With -',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              ////google
              Expanded(
                child: InkWell(
                  onTap: ()async{
                   // final GoogleSignInAccount? googleUser =
                    //     (await signInWithGoogle()) as GoogleSignInAccount?;
                    // if (googleUser != null) {
                    //   // The user has signed in successfully.
                    //   // You can now use their information to authenticate your app.
                    // }
                    try{
                      final userCredential = await signInWithGoogle();
                      print('Signed in as ${userCredential.user!.displayName}');
                      bool role = await isUserDriver();
                        if (role) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Your are driver.'),
                            ),
                          );
                          Navigator.pushNamed(context, 'Driverhome');
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage2(),
                            ),
                          );
                        }

                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Some Error Occurred, Please try again.'),
                        ),
                      );

                    }

                  },
                  child: Container(

                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Image(
                    image: AssetImage('assets/images/google.png'),
                    height: 25,
                  ),
              ),
                ),),
              const SizedBox(width: 10,),
              ////facebook
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Image(
                    image: AssetImage('assets/images/facebook.png'),
                    height: 25,
                  ),
                ),),
              const SizedBox(width: 10,),
              ////twitter
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Image(
                    image: AssetImage('assets/images/twitter.png'),
                    height: 25,
                  ),
                ),),

            ],
          ),
        ),
      ],
    );
  }

}