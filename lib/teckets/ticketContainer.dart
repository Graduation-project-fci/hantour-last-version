import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ticketCard extends StatefulWidget {
  late var passenger_name, source, distnation, price;
  ticketCard(this.passenger_name, this.source, this.distnation, this.price);

  @override
  State<ticketCard> createState() => _ticketCardState();
}

class _ticketCardState extends State<ticketCard> {
  CollectionReference requests =
      FirebaseFirestore.instance.collection('Request');

  void getTripData() {}

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final driverQuerySnapshot = await FirebaseFirestore.instance
  //       .collection('Request')
  //       .doc(user!.uid)
  //       .get();
  //   print(driverQuerySnapshot.id);
  //   return driverQuerySnapshot;
  // }

  // String? name, source, distnation, price;

  // Future<void> fetchData() async {
  //   final userData = await getUserData();
  //   final data = userData.data();
  //   setState(() {
  //     if (data != null) {
  //       name = data['rider_id'] ?? 'not';
  //       source = data['source_location'] ?? 'not';
  //       distnation = data['destination_location'] ?? 'not';
  //     }
  //   });

  //   // do something with the data
  //   print('${name}');
  //   print('${source}');
  //   print('${distnation}');
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/5.jpg',
                ),
              ),
              Text('')
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Ahmed",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "15 LE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(height: 29),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Luxor",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Hantour Company',
                style: TextStyle(color: Colors.white),
              )
            ],
          )
        ],
      ),
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        color: Colors.red,
      ),
    );
  }
}
