//criminal_record
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class criminal_record extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<criminal_record> {
  String _idCardNumber = '';
  String _idCardImagePath = '';
  File? image; // add ? for null safety
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference criminal =
      FirebaseFirestore.instance.collection('CriminalRecords');

  final imagepicker = ImagePicker();
  String downloadUrl = "";
  final FirebaseStorage storage = FirebaseStorage.instance;

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
      print(downloadUrl);

      // setState(() {
      //   image = File(pickedImage.path);
      // });
    }
  }

  Future<void> upload_criminal() async {
    return await criminal
        .doc(_auth.currentUser!.uid)
        .set({'criminalimage': downloadUrl})
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
          padding:
              const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Criminal Record photo',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: image != null ? Image.file(image!) : null,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  uploadImage(_auth.currentUser!.uid, 'criminal_report_images');
                },
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
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      upload_criminal();
                      Navigator.of(context).pushNamed('id');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Piease choose an for criminal record')));
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
