import 'package:flutter/material.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  // Field

  // Method

  Widget showMap() {
    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.height * 0.3,
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Name :',
                prefixIcon: Icon(Icons.account_box),
              ),
            ),
          ),
        ],
      );

  Widget detailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Detail :',
                prefixIcon: Icon(Icons.details),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          nameForm(),
          detailForm(),
          showMap(),
        ],
      ),
    );
  }
}
