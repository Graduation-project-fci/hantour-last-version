import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hantourgo/firebase_Services/authentication.dart';
import 'package:hantourgo/sendNotification/SenderActor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets.dart';

class BasicInfo extends StatefulWidget {
  BasicInfo({super.key});
  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  TextEditingController nameC = TextEditingController();
  TextEditingController birthC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController AddressC = TextEditingController();
  TextEditingController EmailC = TextEditingController();
  TextEditingController PasswordC = TextEditingController();
  TextEditingController ConfirmPasswordC = TextEditingController();
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

  Future<void> insertDriverData(
      String email, String name, String phone, String token) async {
    print('inser driver data ok');
    await Drivers.add(
            {'email': email, 'name': name, 'phone': phone, 'token': token})
        .then((value) => print("Driver Data updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> uploadBasicInfo(String email, String phone, String name) async {
    await basicInfo
        .doc(email)
        .set({'email': email, 'phone': phone, 'name': name})
        .then((value) => print("Data updated basic info"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Future<void> AddDriverDataWithID_As_decument(
  //     String ID, String Email, String name, String phone) async {
  //   await Drivers.doc(ID)
  //       .set({'name': name, 'phone': phone, 'email': Email})
  //       .then((value) => print("Data inserted into Drivers"))
  //       .catchError((error) =>
  //           print("Failed to add Driver to drivers collection: $error"));
  // }

  String Id = 'emptyString';
  Future<String?> getCurrentUserToken() async {
    var token = await firebaseMessaging.getToken();
    return token;
  }

  void SignUpDriver(String Email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email,
        password: password,
      );
      print(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  CollectionReference basicInfo =
      FirebaseFirestore.instance.collection('basicInfo');
  CollectionReference Drivers =
      FirebaseFirestore.instance.collection('Drivers');
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _token = '';
  //  firebaseMessaging.getToken().then((value) => _token=value! );

  File? image; // add ? for null safety
  final FirebaseStorage storage = FirebaseStorage.instance;

  final imagepicker = ImagePicker();
  String downloadUrl = '';

  // Future<void> uploadImage(String currentId, String folder) async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     image = File(pickedImage!.path);
  //   });

  //   if (pickedImage == null) {
  //     print("No Image chosen yet"); // replace Text with print
  //   } else {
  //     final file = File(pickedImage.path);
  //     final reference = storage.ref().child('$folder/$currentId');
  //     final uploadTask = reference.putFile(file);
  //     final snapshot = await uploadTask.whenComplete(() {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Photo Uploaded Successfully '),
  //         ),
  //       );
  //     });
  //     downloadUrl = await snapshot.ref.getDownloadURL();

  //     // setState(() {
  //     //   image = File(pickedImage.path);
  //     // });
  //   }
  // }

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registration Page'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'driverregister');
          },
          child: Icon(Icons.arrow_back_ios),
        ),
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
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {},
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
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  widgets(
                    controller: nameC,
                    text: 'Full Name',
                    obscure: false,
                    textInputType: TextInputType.text,
                    maxlen: 100,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: birthC,
                    text: 'Date of Birth (MM/DD/YYYY)',
                    obscure: false,
                    textInputType: TextInputType.phone,
                    maxlen: 20,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: phoneC,
                    text: 'Phone number',
                    obscure: false,
                    textInputType: TextInputType.phone,
                    maxlen: 20,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: AddressC,
                    text: 'Address',
                    obscure: false,
                    textInputType: TextInputType.streetAddress,
                    maxlen: 100,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: EmailC,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                    maxlen: 100,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: PasswordC,
                    text: 'Password',
                    obscure: true,
                    textInputType: TextInputType.text,
                    maxlen: 8,
                  ),
                  SizedBox(height: 16.0),
                  widgets(
                    controller: ConfirmPasswordC,
                    text: 'Confirm Password',
                    obscure: true,
                    textInputType: TextInputType.text,
                    maxlen: 8,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () async {
                      _token = (await getCurrentUserToken())!;

                      // print(EmailC.text.trim());
                      // print(PasswordC.text.trim());
                      // if (_dobController.text.trim() != "" &&
                      //     _addressController.text.trim() != "") {
                      SignUpDriver(
                          EmailC.text.toString(), PasswordC.text.toString());
                      uploadBasicInfo(EmailC.text.toString(),
                          phoneC.text.toString(), nameC.text.toString());
                      insertDriverData(
                          EmailC.text.toString(),
                          nameC.text.toString(),
                          phoneC.text.toString(),
                          _token.toString());
                      print(_token.toString());
                      // Navigator.of(context).pushNamed('driverlicense');
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
