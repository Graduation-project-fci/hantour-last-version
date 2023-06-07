import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hantourgo/firebase_Services/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets.dart';

class BasicInfo extends StatefulWidget {
  BasicInfo({super.key});
  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
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

  Future<String> getFieldFromDocument(
      String collectionName, String documentId, String fieldName) async {
    try {
      // Get a reference to the Firestore collection and document
      final collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      final documentRef = collectionRef.doc(documentId);

      // Use the get() method to retrieve the document data
      final documentSnapshot = await documentRef.get();

      // Check if the document exists and contains the requested field
      if (documentSnapshot.exists &&
          documentSnapshot.data()!.containsKey(fieldName)) {
        // Return the value of the requested field
        return documentSnapshot.get(fieldName);
      } else {
        // Document or field does not exist
        return 'nooooo';
      }
    } catch (e) {
      // Error occurred while reading from Firestore
      print('Error: $e');
      return 'noooo 2';
    }
  }

  Future<void> uploadBasicInfo() {
    return basicInfo
        .doc(_auth.currentUser!.uid)
        .set({
          'ImageLink': downloadUrl,
          'Phone': _dobController.text.trim(),
          'address': _addressController.text.trim()
        })
        .then((value) => print("Data updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  CollectionReference basicInfo =
      FirebaseFirestore.instance.collection('basicInfo');
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? image; // add ? for null safety
  final FirebaseStorage storage = FirebaseStorage.instance;

  final imagepicker = ImagePicker();
  String downloadUrl = '';

  Future<void> uploadImage(String currentId, String folder) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage!.path);
    });

    if (pickedImage == null) {
      print("No Image chosen yet"); // replace Text with print
    } else {
      final file = File(pickedImage.path);
      final reference = storage.ref().child('$folder/$currentId');
      final uploadTask = reference.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo Uploaded Successfully '),
          ),
        );
      });
      downloadUrl = await snapshot.ref.getDownloadURL();

      // setState(() {
      //   image = File(pickedImage.path);
      // });
    }
  }

  File? image1; // add ? for null safety

  final imagepicker1 = ImagePicker();

  Future<void> chooseimagefromgallary() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      print("No Image chosen yet"); // replace Text with print
    } else {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  // Future<void>uploadImageToServer(FileImage img,String folder,String id){
  //
  // }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController PhoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController ConfpasswordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        backgroundColor: const Color(0xFF0B0742),
      ),
      body: SingleChildScrollView(
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
              onPressed: () {
                uploadImage(_auth.currentUser!.uid, 'personal_images');
              },
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  widgets(
                    controller: nameController,
                    text: 'Full Name',
                    obscure: false,
                    textInputType: TextInputType.text,
                    maxlen: 100,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: dateController,
                    text: 'Date of Birth (MM/DD/YYYY)',
                    obscure: false,
                    textInputType: TextInputType.phone,
                    maxlen: 20,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: PhoneController,
                    text: 'Phone number',
                    obscure: false,
                    textInputType: TextInputType.phone,
                    maxlen: 20,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: addressController,
                    text: 'Address',
                    obscure: false,
                    textInputType: TextInputType.streetAddress,
                    maxlen: 100,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                    maxlen: 100,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: passwordController,
                    text: 'Password',
                    obscure: true,
                    textInputType: TextInputType.text,
                    maxlen: 8,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: ConfpasswordController,
                    text: 'Confirm Password',
                    obscure: true,
                    textInputType: TextInputType.text,
                    maxlen: 8,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_dobController.text.trim() != "" &&
                          _addressController.text.trim() != "") {
                        uploadBasicInfo();
                      }

                      Navigator.of(context).pushNamed('driverlicense');
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B0742),
                      textStyle: TextStyle(
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
