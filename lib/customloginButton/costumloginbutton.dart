import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/screens/loginpage.dart';

class Costumbuttonforlogin extends StatelessWidget {
  // const button({Key? key}) : super(key: key);
  String? text, screen, email, password;
  late TextEditingController cemail, cpass;

  Costumbuttonforlogin(
      String text,
      String? screen,
      String email,
      String password,
      TextEditingController cemail,
      TextEditingController cpass) {
    this.text = text;
    this.screen = screen;
    this.email = email;
    this.password = password;
    this.cemail = cemail;
    this.cpass = cpass;
  }
  CollectionReference users =
      FirebaseFirestore.instance.collection('Passenger_registeration');

  // Future<Object?> navigator(String? screen) async {
  //   return await Navigator.of(context).pushNamed(screen!);
  // }
  Future<bool> _loginUser(String email, String password) async {
    print(email + ' ' + password);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'mostafammalik751@gmail.com',
        password: 'xxx',
      );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await _loginUser(email!, password!) == true) {
          Navigator.of(context).pushNamed(screen!);
        }
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
        child: Text('$text',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}
