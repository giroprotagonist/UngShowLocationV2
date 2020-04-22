import 'package:flutter/material.dart';
import 'package:ungshowlocation/utility/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  String gendle;

  // Method
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().primaryColor,
        title: Text('Register'),
      ),
      body: ListView(padding: EdgeInsets.only(bottom: 50.0),
        children: <Widget>[
          showAvatar(),
          showButton(),
          nameForm(),
          chooseGendle(),
          emailForm(),
          passwordForm(),
        ],
      ),
    );
  }

  Row chooseGendle() => Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          maleRadio(),
          femaleRadio(),
        ],
      );

  Row maleRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Male',
            groupValue: gendle,
            onChanged: (value) {},
          ),
          Text('Male'),
        ],
      );

  Row femaleRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Female',
            groupValue: gendle,
            onChanged: (value) {},
          ),
          Text('Female'),
        ],
      );

  Widget nameForm() {
    String title = 'Display Name :';
    String subTitle = 'Type Your Name in Blank';
    IconData iconData = Icons.account_box;
    Color color = Colors.green;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            decoration: InputDecoration(
              helperText: subTitle,
              helperStyle: TextStyle(color: color),
              labelText: title,
              labelStyle: TextStyle(color: color),
              icon: Icon(
                iconData,
                size: 36.0,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget emailForm() {
    String title = 'Email :';
    String subTitle = 'Type Your Email in Blank';
    IconData iconData = Icons.email;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              helperText: subTitle,
              labelText: title,
              icon: Icon(
                iconData,
                size: 36.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordForm() {
    String title = 'Password :';
    String subTitle = 'Type Your Password in Blank';
    IconData iconData = Icons.lock;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            decoration: InputDecoration(
              helperText: subTitle,
              labelText: title,
              icon: Icon(
                iconData,
                size: 36.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add_a_photo),
          label: Text('Camera'),
        ),
        RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add_photo_alternate),
          label: Text('Gallery'),
        ),
      ],
    );
  }

  Widget showAvatar() => Container(
        margin: EdgeInsets.all(30.0),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Image.asset('images/avatar.png'),
      );
} // Class
