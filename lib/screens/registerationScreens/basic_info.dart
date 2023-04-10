// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class basic_info extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<basic_info> {
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();

//   File? image;
//   final imagepicker = ImagePicker();
//   Future<void> uploadImage() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage == null) {
//       Text("No Image chosen yet");
//     } else {
//       image = File(pickedImage!.path);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration Page'),
//         backgroundColor: Color(0xFF000080),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 16.0),
//             CircleAvatar(
//               radius: 50.0,
//               backgroundColor: Colors.grey,
//               backgroundImage: FileImage((image != null) as File),
//             ),
//             SizedBox(height: 8.0),
//             ElevatedButton(
//               onPressed: uploadImage,
//               child: Text(
//                 'Add a Photo',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                   side: BorderSide(
//                     color: Colors.grey,
//                     width: 1.0,
//                   ),
//                 ),
//               ),
//             ),
//             TextField(
//               controller: _dobController,
//               decoration: InputDecoration(
//                 labelText: 'Date of Birth (MM/DD/YYYY)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: 'Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, 'certificate');
//               },
//               child: Text(
//                 'Next',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF000080),
//                 textStyle: TextStyle(
//                   fontSize: 40.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hantourgo/firebase_Services/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BasicInfo extends StatefulWidget {
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

  Future<String> getFieldFromDocument(String collectionName, String documentId, String fieldName) async {
    try {
      // Get a reference to the Firestore collection and document
      final collectionRef = FirebaseFirestore.instance.collection(collectionName);
      final documentRef = collectionRef.doc(documentId);

      // Use the get() method to retrieve the document data
      final documentSnapshot = await documentRef.get();

      // Check if the document exists and contains the requested field
      if (documentSnapshot.exists && documentSnapshot.data()!.containsKey(fieldName)) {
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
        'ImageLink':downloadUrl,
      'Phone':_dobController.text.trim(),
      'address':_addressController.text.trim()
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
String downloadUrl='';


  Future<void> uploadImage(String currentId,String folder) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image =File(pickedImage!.path);
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
  final FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        backgroundColor: const Color(0xFF000080),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           const SizedBox(height: 16.0),
            CircleAvatar(
              radius: 50.0,
              backgroundImage: image != null // add null check operator
                  ? FileImage(image!) // add non-null assertion operator
                  : null,

            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: (){
                uploadImage(_auth.currentUser!.uid, 'personal_images') ;




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

            TextField(
              onChanged: (v){

              }  ,
              // onTap: ()async{ update image
              //   print(_auth.currentUser!.uid) ;
              //   print(await getFieldFromDocument('basicInfo',_auth.currentUser!.uid,'ImageLink') );
              // }

              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
            ),


            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if(_dobController.text.trim() != "" && _addressController.text.trim() != "") {
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
                backgroundColor: Color(0xFF000080),
                textStyle: TextStyle(
                  fontSize: 40.0,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
