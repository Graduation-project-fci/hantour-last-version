import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/button.dart';
import 'package:hantourgo/widgets.dart';

class signupscreen extends StatelessWidget {
  const signupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Passenger_registeration');
    TextEditingController nameController = TextEditingController();
    TextEditingController PhoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController ConfpasswordController = TextEditingController();
    String? fname;
    String? phone;
    String? email;
    String? password;
    String? confirmpassword;
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
                widgets(
                  data: widgets.data,
                  maxlen: 100,
                  controller: nameController,
                  text: 'Full Name',
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                widgets(
                  data: widgets.data,
                  maxlen: 11,
                  controller: PhoneController,
                  text: 'Phone Number',
                  obscure: false,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 25),
                widgets(
                  data: widgets.data,
                  maxlen: 100,
                  controller: emailController,
                  text: 'Email',
                  obscure: false,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 25),
                widgets(
                  data: widgets.data,
                  maxlen: 100,
                  controller: passwordController,
                  text: 'Password',
                  obscure: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 25),
                widgets(
                  data: widgets.data,
                  maxlen: 100,
                  controller: ConfpasswordController,
                  text: 'Confirm Password',
                  obscure: true,
                  textInputType: TextInputType.text,
                ),

                SizedBox(height: 25),
                //button('Sign Up here', 'basicinfo'),
                InkWell(
                  onTap: () {
                    print(nameController.text);
                    users
                        .add({
                          'fullname': nameController.text,
                          'email': emailController.text,
                          'phone_number': PhoneController.text,
                          'password': passwordController.text
                        })
                        .then((value) => print('User added'))
                        .catchError(
                            (error) => print('Failed to add user: $error'));
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
                    child: Text('Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
