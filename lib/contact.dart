import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'container.dart';

class contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contact Us"),
          backgroundColor: Color(0xFF0B0742),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Container(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/hantour1.png'),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => launch('tel:+201234567890'),
                child: container(text: "Call Us"),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => launch('mailto:support@example.com'),
                child: container(text: "Email Us"),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () =>
                    launch('https://github.com/Graduation-project-fci'),
                child: container(text: "GitHub"),
              ),
            ],
          ),
        ));
  }
}
