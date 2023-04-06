import 'package:flutter/material.dart';

class rating extends StatefulWidget {
  const rating({super.key});

  @override
  State<rating> createState() => _ratingState();
}

class _ratingState extends State<rating> {
  Color iconcolor = Colors.grey;
  Color iconcolor2 = Colors.grey;
  Color iconcolor3 = Colors.grey;
  Color iconcolor4 = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 42, 70),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        iconcolor == Colors.yellow
                            ? iconcolor = Colors.grey
                            : iconcolor = Colors.yellow;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: iconcolor,
                      size: 50,
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        iconcolor2 == Colors.yellow
                            ? iconcolor2 = Colors.grey
                            : iconcolor2 = Colors.yellow;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: iconcolor2,
                      size: 50,
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        iconcolor3 == Colors.yellow
                            ? iconcolor3 = Colors.grey
                            : iconcolor3 = Colors.yellow;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: iconcolor3,
                      size: 50,
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        iconcolor4 == Colors.yellow
                            ? iconcolor4 = Colors.grey
                            : iconcolor4 = Colors.yellow;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: iconcolor4,
                      size: 50,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
