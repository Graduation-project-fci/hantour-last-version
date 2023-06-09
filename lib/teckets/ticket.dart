import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hantourgo/reports/ticket.dart';
import 'package:hantourgo/screens/driverscreens/driver_home.dart';
import 'package:hantourgo/teckets/ticketContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketData {
  late String _id;
  late String ImageLink;
  late String source = '';
  late String distnation = '';
  late String distance = '';
  late String price = '';
  String phone_number = '';
  TicketData(
    String _id,
    this.ImageLink,
    String source,
    String distnation,
    String distance,
    String price,
    String phone_number,
  ) {
    this._id = _id;
    this.source = source;
    this.distnation = distnation;
    this.distance = distance;
    this.price = price;
    this.phone_number = phone_number;
  }
}

late TicketData x = TicketData('', '', '', '', '', '', '');

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Orders"),
          backgroundColor: Color.fromARGB(255, 9, 67, 114),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Requests')
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    x = TicketData(
                        document.id,
                        '${document['image']}',
                        '${document['source_location']}',
                        '${document['destination_location']}',
                        '${document['price']}',
                        '10',
                        '${document['phone_number']}');
                    print(x.ImageLink);
                    print(x._id);
                    print(x.source);
                    print(x.distnation);
                    print(x.distance);
                    print(x.price);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => driverHome(id: x._id))));
                  },
                  child: Center(
                    child: Container(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/images/1.jpg'),
                                    image: NetworkImage('${document['image']}'),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 25),
                                child: Text(
                                  '${document['name']}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text(
                                      "${document['source_location']}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
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
                                          color: Colors.white,
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
                                const Text(
                                  "Distance :  meter",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${document['price']} \$",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                        color: Color.fromARGB(255, 9, 67, 114),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
