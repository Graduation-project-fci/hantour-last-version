import 'dart:io';

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
  File? image1, image; // add ? for null safety

  final imagepicker1 = ImagePicker();

  Future<void> uploadImage1() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      print("No Image chosen yet"); // replace Text with print
    } else {
      setState(() {
        image1 = File(pickedImage.path);
      });
    }
  }

  final imagepicker = ImagePicker();

  Future<void> uploadImage() async {
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
                    image != null ? Image.file(image!) : null, // add null check
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadImage,
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
                child: image1 != null ? Image.file(image1!) : null,
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: uploadImage1,
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
                    Navigator.of(context).pushNamed('criminal');
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
