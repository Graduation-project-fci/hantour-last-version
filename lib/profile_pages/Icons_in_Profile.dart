import 'package:flutter/material.dart';

class Custom_icons extends StatelessWidget {
  Icon icon = new Icon(Icons.man);
  String? text;
  Custom_icons(Icon ic, String? text) {
    this.icon = ic;
    this.text = text.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [this.icon, Text('$this.text')],
      ),
    );
  }
}
