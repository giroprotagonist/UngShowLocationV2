import 'package:flutter/material.dart';

class MyStyle {
  // Field
  Color darkColor = Color.fromARGB(0xff, 0x00, 0x2f, 0x6c);
  Color primaryColor = Color.fromARGB(0xff, 0x01, 0x57, 0x9b);

  Widget showPrograss() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showTitle(String string) {
    return Row(
      children: <Widget>[
        Container(margin: EdgeInsets.all(10.0),
          child: Text(
            string,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0x00, 0x2f, 0x6c),
            ),
          ),
        ),
      ],
    );
  }

  // Method
  MyStyle();
}
