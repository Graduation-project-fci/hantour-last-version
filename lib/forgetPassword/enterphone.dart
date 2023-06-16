import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/ANIMATION/showDialog.dart';
import 'package:hantourgo/sendNotification/SenderActor.dart';
import 'package:hantourgo/sendNotification/api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

import '../screens/loginpage.dart';

class EnterPhoneForgetPassword extends StatefulWidget {
  const EnterPhoneForgetPassword({super.key});

  @override
  State<EnterPhoneForgetPassword> createState() =>
      _EnterPhoneForgetPasswordState();
}

class _EnterPhoneForgetPasswordState extends State<EnterPhoneForgetPassword> {
  TextEditingController mailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  color: Color.fromARGB(255, 94, 114, 235),
                  height: MediaQuery.of(context).size.height * 0.11,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_clock,
                        color: Color(0x5E72EB),
                      )
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 94, 114, 235),
                ),
                child: Expanded(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.29),
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 11, 7, 66),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Text(
                                        "Enter your Email",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 55,
                                        padding: const EdgeInsets.only(
                                            top: 3, left: 15),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 7,
                                            )
                                          ],
                                        ),
                                        child: Form(
                                          // key: passkey,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.length < 11) {
                                                return 'Invalid Email';
                                              }
                                              return null;
                                            },
                                            // controller: passwordController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            obscureText: false,
                                            controller: mailController,
                                            decoration: InputDecoration(
                                                hintText: 'Enter Your Email',
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                hintStyle: const TextStyle(
                                                  height: 1,
                                                )),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          try {
                                            if (mailController.text
                                                .trim()
                                                .isNotEmpty) {
                                              await FirebaseAuth.instance
                                                  .sendPasswordResetEmail(
                                                      email: mailController.text
                                                          .trim());
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'reset Password Email sent Successfully'),
                                                ),
                                              );
                                              showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return AnimatedErrorDialog(
                                                      errorMessage:
                                                          "Email Sent Successfully",
                                                      ErrorTitle: "Successful",
                                                      icon: Icons
                                                          .supervised_user_circle,
                                                    );
                                                  }));
                                              // Navigator.pushNamed(
                                              //     context, "login");
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'You Must Enter valid Email address'),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return AnimatedErrorDialog(
                                                    errorMessage:
                                                        "Enter Correct Email",
                                                    ErrorTitle: "Error",
                                                    icon: Icons.error_outline,
                                                  );
                                                }));
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 55,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 80, 74, 158),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                )
                                              ]),
                                          child: const Text(
                                            'Send',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    loginpage()),
                                          );
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Image.asset('assets/images/horse.png'),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
