import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class nationalID extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<nationalID> {
  TextEditingController IDController = TextEditingController() ;
  String _idCardNumber = '';
  String _idCardImagePath = '';
  File? imagefront;
  File? imageback;// add ? for null safety
  final FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference NationalId =
  FirebaseFirestore.instance.collection('NationalId');

  Future<void> upload_national_id() {
    return NationalId
        .doc(_auth.currentUser!.uid)
        .set({
      'idCardBack':downloadUrlback,
      'idCardFront':downloadUrlfront,
      'nationIdCard':IDController.text.trim().toString()
    })
        .then((value) => print("Data updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  final imagepicker = ImagePicker();
  String downloadUrlfront='';
  String downloadUrlback='';

  Future<void> uploadImage(String currentId,String folder  ,String downloadimage) async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if(folder=='NationalId/front'){
        imagefront =File(pickedImage!.path);

      }else if(folder=='NationalId/back'){
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
      if(folder=='NationalId/front'){
        downloadUrlfront=await snapshot.ref.getDownloadURL();
      }else if(folder=='NationalId/back'){
        downloadUrlback=await snapshot.ref.getDownloadURL();
      }


      // setState(() {
      //   image = File(pickedImage.path);
      // });
    }

  }
  final FirebaseAuth _auth=FirebaseAuth.instance;


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
                'National ID card photo (front)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: imagefront != null
                    ? Image.file(imagefront!)
                    : Center(
                  child: Text('No image selected'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: ()async{
                    await uploadImage(_auth.currentUser!.uid, 'NationalId/front' ,downloadUrlfront);
                    print('front ${downloadUrlfront} \n back: ${downloadUrlback}');

                  },
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
                'National ID card photo (back)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: imageback != null
                    ? Image.file(imageback!)
                    : Center(
                  child: Text('No image selected'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: ()async{
                    await uploadImage(_auth.currentUser!.uid, 'NationalId/back' ,downloadUrlback);

                  },
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
                'National ID card number',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: IDController,
                onEditingComplete: (){

                },
                decoration: InputDecoration(
                  hintText: 'Enter ID card number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 14,
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (imageback != null && imagefront != null) {
                      Navigator.of(context).pushNamed('select');
                      upload_national_id();
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Piease choose an IMAGE for national id')));
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
