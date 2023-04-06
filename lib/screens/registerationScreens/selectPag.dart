import 'package:flutter/material.dart';

class selectPag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Color(0xFF000080),
      ),
      backgroundColor: Color(0xFFCBCBCB),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
            child: Container(
              color: Colors.white70,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title:
                        Text('Driver', style: TextStyle(color: Colors.black)),
                    trailing: Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Navigator.pushNamed(context, 'driverregister');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Passenger',
                        style: TextStyle(color: Colors.black)),
                    trailing: Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
