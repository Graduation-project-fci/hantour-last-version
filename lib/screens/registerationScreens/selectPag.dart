import 'package:flutter/material.dart';

class selectPag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0742),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/images/select.png'),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('driverregister');
                          },
                          child: ListTile(
                            title: Text('Driver',
                                style: TextStyle(color: Colors.white)),
                            trailing:
                                Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'signup');
                          },
                          child: ListTile(
                            title: Text('Passenger',
                                style: TextStyle(color: Colors.white)),
                            trailing:
                                Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //  Divider(),
                ],
              )
              /*       Column(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('driver_register');
                  },
          child: Text(
            'Driver',
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
        SizedBox(height: 40.0),
        ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'signup');
                  },
                  child: Text(
                    'Passenger',
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
            ],
          ),*/
            ],
          ),
        ),
      ),
    );
  }
}
