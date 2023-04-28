import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/screens/registerationScreens/basic_info.dart';
import 'package:image_picker/image_picker.dart';

class driverLicense extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<driverLicense> {
  String _idCardNumber = '';
  String _idCardImagePath = '';
  final TextEditingController _dobController = TextEditingController();
  File? imagefront;
  File? imageback;// add ? for null safety
  final FirebaseStorage storage = FirebaseStorage.instance;


  final imagepicker = ImagePicker();
  String downloadUrlfront='';
  String downloadUrlback='';
  String  downloadUrl="";

  Future<void> uploadImage(String currentId,String folder) async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if(folder=='driver_licence/front'){
        imagefront =File(pickedImage!.path);
      }else if(folder=='driver_licence/back'){
        imageback =File(pickedImage!.path);
      }

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
      if(folder=='driver_licence/front'){
        downloadUrlfront=await snapshot.ref.getDownloadURL();
      }else if(folder=='driver_licence/back'){
        downloadUrlback=await snapshot.ref.getDownloadURL();
      }
    }
  }
  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference Licence =
  FirebaseFirestore.instance.collection('DriverLicence');

  Future<void> upload_license() async{
    return await Licence
        .doc(_auth.currentUser!.uid)
        .set({
      'back_driver_licence':downloadUrlback,
      'front_driver_licence':downloadUrlfront,

    })
        .then((value) => print("Data updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Color(0xFF0B0742),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver License card photo (front)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child:
                imagefront != null ? Image.file(imagefront!) : null, // add null check
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: ()=>uploadImage(_auth.currentUser!.uid,'driver_licence/front'),
                  child: Text(
                    'Select Image',
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
              ),
              SizedBox(height: 20.0),
              Text(
                'Driver License card photo (back)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: imageback != null ? Image.file(imageback!) : null,
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: ()=>uploadImage(_auth.currentUser!.uid,'driver_licence/back'),
                  child: Text(
                    'Select Image',
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
              ),
              SizedBox(height: 20.0),
              Text(
                'Driver License number',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                maxLength: 14,
                decoration: InputDecoration(
                  hintText: 'Enter ID card number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              Text(
                'Date of expiration',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  hintText: 'Date of expiration (MM/DD/YYYY)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (imageback != null && imagefront != null) {
                      upload_license();
                      Navigator.of(context).pushNamed('criminal');
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Piease choose an IMAGE')));
                    }

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
