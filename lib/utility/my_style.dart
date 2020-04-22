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

  // Method
  MyStyle();
}
