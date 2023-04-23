import 'package:flutter/material.dart';

class mywallet extends StatefulWidget {
  const mywallet({super.key});

  @override
  State<mywallet> createState() => _mywalletState();
}

class _mywalletState extends State<mywallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Driver Wallet"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
            ),
            Container(
              child: Text(
                "Mostafa Malik",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total:",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text("3000 L.E",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
              height: 100,
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 43, 178, 219),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Points:",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text("150 Point",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
              height: 100,
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 43, 178, 219),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ]),
              child: const Text('Sent Money by Vodafone Cash',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
