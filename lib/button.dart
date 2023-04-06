import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/screens/loginpage.dart';

class button extends StatelessWidget {
  // const button({Key? key}) : super(key: key);
  String? text, screen;
  button(String text, String? screen) {
    this.text = text;
    this.screen = screen;
  }
  CollectionReference users =
      FirebaseFirestore.instance.collection('Passenger_registeration');

  // Future<Object?> navigator(String? screen) async {
  //   return await Navigator.of(context).pushNamed(screen!);
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(screen!);
      },
      onLongPress: () {
        users
            .add({
              'fullname': 'farrag',
              'email': 'farrag@gmail.com',
              'phone_number': '0114445',
              'password': '123456'
            })
            .then((value) => print('User added'))
            .catchError((error) => print('Failed to add user: $error'));
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
