import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hantourgo/screens/loginpage.dart';

class fpage extends StatelessWidget {
  // const fpage({key? key}) : super(key: key);
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Get.to(loginpage());
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 128),
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
          height: 600,
        ),
      ),
    );
  }
}
