import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class nationalID extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<nationalID> {
  String _idCardNumber = '';
  String _idCardImagePath = '';
  final imagepicker1 = ImagePicker();
  File? imagefrontID, imagebackID;

  Future<void> uploadImagefront() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      print("No Image chosen yet"); // replace Text with print
    } else {
      setState(() {
        imagefrontID = File(pickedImage.path);
      });
    }
  }

  Future<void> uploadImageback() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      print("No Image chosen yet"); // replace Text with print
    } else {
      setState(() {
        imagebackID = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Color(0xFF000080),
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
                child: imagefrontID != null
                    ? Image.file(imagefrontID!)
                    : Center(
                        child: Text('No image selected'),
                      ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadImagefront,
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
                child: imagebackID != null
                    ? Image.file(imagebackID!)
                    : Center(
                        child: Text('No image selected'),
                      ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadImageback,
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
                    Navigator.pushNamed(context, 'select');
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF000080),
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
