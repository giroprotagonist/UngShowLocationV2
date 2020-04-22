import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ungshowlocation/utility/my_style.dart';
import 'package:ungshowlocation/utility/normal_dialog.dart';
import 'package:ungshowlocation/widget/my_service.dart';


class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  // Field
  String user, password;

  // Method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser != null) {
      routeToMap();
    }
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Text showAppName() => Text(
        'Ung Show Location',
        style: GoogleFonts.satisfy(
            textStyle: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: MyStyle().darkColor,
        )),
      );

  //  Text showAppName(){
  //    print('hello');
  //    return Text('Geolocation');
  //  }

  Container userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (String string) {
          user = string.trim();
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.white),
          hintText: 'Eng Only',
          border: OutlineInputBorder(),
          labelText: 'User :',
        ),
      ),
    );
  }

  Container passwordForm() {
    return Container(
      width: 250.0,
      child: TextField(
        obscureText: true,
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password :',
        ),
      ),
    );
  }

  Widget mySizeBox() {
    return SizedBox(
      height: 16.0,
      width: 8.0,
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInButton(),
        mySizeBox(),
        signUpButton(),
      ],
    );
  }

  OutlineButton signUpButton() => OutlineButton(
        borderSide: BorderSide(color: MyStyle().darkColor),
        onPressed: () {},
        child: Text(
          'Sign Up',
          style: TextStyle(color: MyStyle().darkColor),
        ),
      );

  RaisedButton signInButton() {
    return RaisedButton(
      color: MyStyle().darkColor,
      onPressed: () {
        print('user = $user, password = $password');
        if (user == null ||
            user.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          cheackAuthen();
        }
      },
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> cheackAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: user, password: password)
        .then((response) {
      print('Success Authen');

      routeToMap();
    }).catchError((response) {
      print('response catchError ==> ${response.toString()}');
      String title = response.code;
      String message = response.message;
      normalDialog(context, title, message);
    });
  }

  void routeToMap() {
    MaterialPageRoute route =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService();
    });
    Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.0,
            colors: <Color>[Colors.white, MyStyle().primaryColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                mySizeBox(),
                showAppName(),
                mySizeBox(),
                userForm(),
                mySizeBox(),
                passwordForm(),
                showButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
