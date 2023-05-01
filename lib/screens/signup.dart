import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/button.dart';
import 'package:hantourgo/widgets.dart';

class signupscreen extends StatelessWidget {
  signupscreen({super.key});
  final _formKey = GlobalKey<FormState>();
  CollectionReference Riders = FirebaseFirestore.instance.collection('Riders');
  final FirebaseAuth auth = FirebaseAuth.instance;


  //set new Rider
  Future<void> addRider(String name,String phone,String email ) {
    // Call the user's CollectionReference to add a new user
    return Riders.doc(auth.currentUser!.uid).set({
      'name':name,'phone':phone,'email':email,'personal_photo':'https://crda.ap.gov.in/apcrdadocs/EMPLOYE%20PHOTOS/user.png'
    })

        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //validate Phone number func
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (!phoneExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }


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
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Color(0xFF0B0742),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/login.jpg'),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: (){},
                //onPressed:()=> uploadImage(_auth.currentUser!.uid,"personal_images"),
                child: Text(
                  'Add a Photo',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // alignment: Alignment.center,
              // const SizedBox(height: 0),
              // Text('Login to your account',
              //   style: TextStyle(color: Colors.black,
              //    fontSize: 16,
              //    fontWeight: FontWeight.w500,),),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    widgets(
                      data: widgets.data,
                      maxlen: 100,
                      controller: nameController,
                      text: 'Full Name ',
                      obscure: false,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    widgets(
                      data: widgets.data,
                      maxlen: 20,
                      controller: PhoneController,
                      text: 'Phone Number',
                      validator: validatePhoneNumber,

                      obscure: false,
                      textInputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 25),
                    widgets(
                        data: widgets.data,
                        maxlen: 100,
                        controller: emailController,
                        text: 'Email',
                        obscure: false,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          final RegExp regex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            caseSensitive: false,
                            multiLine: false,
                          );
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }if(!regex.hasMatch(value.trim())){
                            return 'Please Enter Valid Email address';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 25),
                    widgets(
                      data: widgets.data,
                      maxlen: 8,
                      controller: passwordController,
                      text: 'Password',
                      obscure: true,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.length<6) {
                          return 'Too Short Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    widgets(
                      data: widgets.data,
                      maxlen: 8,
                      controller: ConfpasswordController,
                      text: 'Confirm Password',
                      obscure: true,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.length<6) {
                          return 'Too Short Password';
                        }if(value!=passwordController.text){
                          return 'Password does not match.';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 25),
                    //button('Sign Up here', 'basicinfo'),
                    InkWell(
                      onTap: ()async {
                        // try{
                        //   if(_formKey.currentState!.validate()){
                        //     // print(nameController.text);
                        //     // users
                        //     //     .add({
                        //     //   'fullname': nameController.text,
                        //     //   'email': emailController.text,
                        //     //   'phone_number': PhoneController.text,
                        //     //   'password': passwordController.text
                        //     // })
                        //     //     .then((value) => print('User added'))
                        //     //     .catchError(
                        //     //         (error) => print('Failed to add user: $error'));
                        //   }
                        // }catch(e){
                        //   print(e);
                        //
                        // }
                        if(_formKey.currentState!.validate()){
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            addRider(nameController.text.trim(),PhoneController.text.trim(),emailController.text.trim());

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('The password provided is too weak.'),
                                ),
                              );

                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('The account already exists for that email.'),
                                ),
                              );
                              print('The account already exists for that email.');
                            }
                          } catch (e) {
                            print(e);
                          }
                        }



                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xFF0B0742),
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
                      ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
