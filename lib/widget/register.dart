import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungshowlocation/utility/my_style.dart';
import 'package:ungshowlocation/utility/normal_dialog.dart';
import 'package:ungshowlocation/widget/my_service.dart';
import 'package:ungshowlocation/widget/show_map.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  String gendle, name, email, password, urlAvatar, uid;
  File file;

  // Method
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(
              context, 'Non Choose Avatar', 'Please Tap Camera or Gallery');
        } else if (name == null ||
            name.isEmpty ||
            email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else if (gendle == null) {
          normalDialog(
              context, 'Non Choose Gendle', 'Please Tap Male or Female');
        } else {
          uploadImageToFirebase();
        }
      },
    );
  }

  Future<void> uploadImageToFirebase() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String fileName = 'avatar$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference reference =
        firebaseStorage.ref().child('Avatar/$fileName');
    StorageUploadTask storageUploadTask = reference.putFile(file);

    urlAvatar = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('urlAvatar ==>> $urlAvatar');
    registerAuthen();
  }

  Future<void> registerAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser firebaseUser = value.user;
      uid = firebaseUser.uid;
      print('Uid ==>> $uid');

      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      userUpdateInfo.photoUrl = urlAvatar;
      firebaseUser.updateProfile(userUpdateInfo);
      insertValueToFirestore();
    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      normalDialog(context, title, message);
    });
  }

  Future<void> insertValueToFirestore() async {
    Map<String, dynamic> map = Map();
    map['Email'] = email;
    map['Gendle'] = gendle;
    map['Name'] = name;
    map['Uid'] = uid;
    map['UrlAvatar'] = urlAvatar;

    Firestore firestore = Firestore.instance;
    CollectionReference reference = firestore.collection('UserCollect');
    await reference
        .document(uid)
        .setData(map)
        .then((value) {
          MaterialPageRoute route = MaterialPageRoute(builder: (value)=>MyService());
          Navigator.of(context).pushAndRemoveUntil(route, (value)=>false);
        })
        .catchError((value) {
      String title = value.code;
      String message = value.message;
      normalDialog(context, title, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().primaryColor,
        title: Text('Register'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 50.0),
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

  Row chooseGendle() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
            onChanged: (value) {
              setState(() {
                gendle = value;
              });
            },
          ),
          Text('Male'),
        ],
      );

  Row femaleRadio() => Row(
        children: <Widget>[
          Radio(
            value: 'Female',
            groupValue: gendle,
            onChanged: (value) {
              setState(() {
                gendle = value;
              });
            },
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
            onChanged: (value) => name = value.trim(),
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
            onChanged: (value) => email = value.trim(),
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
            onChanged: (value) => password = value.trim(),
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
          onPressed: () {
            getAvatar(ImageSource.camera);
          },
          icon: Icon(Icons.add_a_photo),
          label: Text('Camera'),
        ),
        RaisedButton.icon(
          onPressed: () => getAvatar(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
          label: Text('Gallery'),
        ),
      ],
    );
  }

  Future<void> getAvatar(ImageSource source) async {
    try {
      var result = await ImagePicker.pickImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = result;
      });
    } catch (e) {}
  }

  Widget showAvatar() {
    return Container(
      margin: EdgeInsets.all(30.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }
} // Class
