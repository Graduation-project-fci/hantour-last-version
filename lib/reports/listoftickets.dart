import 'package:flutter/material.dart';
import 'package:hantourgo/reports/ticket2.dart';

class reportOfTickets extends StatefulWidget {
  const reportOfTickets({super.key});

  @override
  State<reportOfTickets> createState() => _reportOfTicketsState();
}

class _reportOfTicketsState extends State<reportOfTickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ticket2(),
            ticket2(),
            ticket2(),
            ticket2(),
            ticket2(),
            ticket2(),
          ],
        ),
      ),
    );
  }
}
