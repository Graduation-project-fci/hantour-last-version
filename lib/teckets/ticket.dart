import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/reports/ticket.dart';
import 'package:hantourgo/screens/driverscreens/driver_home.dart';
import 'package:hantourgo/teckets/ticketContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketData {
  late String ImageLink;
  late String source;
  late String distnation;
  late String distance;
  late String price;
  TicketData(String ImageLink, String source, String distnation,
      String distance, String price) {
    this.ImageLink = ImageLink;
    this.source = source;
    this.distnation = distnation;
    this.distance = distance;
    this.price = price;
  }
}

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Requests').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.vertical,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () {
                  final x = TicketData(
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80',
                      '${document['source_location']}',
                      '${document['destination_location']}',
                      '${document['price']}',
                      '10');
                  print(x.ImageLink);
                  print(x.source);
                  print(x.distnation);
                  print(x.distance);
                  print(x.price);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => driverHome(x.ImageLink,
                              x.source, x.distnation, x.distance, x.price))));
                },
                child: Center(
                  child: Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image(
                                  // image: NetworkImage('${document['image']}'),
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80'),
                                  fit: BoxFit.cover, // Add this line
                                  width:
                                      60, // Add this line to specify the width of the image
                                  height:
                                      60, // Add this line to specify the height of the image
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Text(
                                    "${document['source_location']}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text(
                                      "${document['destination_location']}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Distance :  meter",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${document['price']} \$",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Hantour Company',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.blue,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
