import 'package:flutter/material.dart';

class ticket2 extends StatelessWidget {
  const ticket2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2.0,
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8.0),
              Text('Event Date'),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 8.0),
              Text('Event Location'),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('Buy Ticket'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
