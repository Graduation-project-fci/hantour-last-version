import 'package:flutter/material.dart';

class container extends StatelessWidget {
  container({required this.text});
  String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF0B0742),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 400,
        child: Center(
          child: Text(text!,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
        ),
      ),
    );
  }
}
