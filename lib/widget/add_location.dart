import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ungshowlocation/utility/my_style.dart';
import 'package:ungshowlocation/utility/normal_dialog.dart';
import 'package:ungshowlocation/widget/my_service.dart';

class AddLocation extends StatefulWidget {
  final double lat;
  final double lng;
  AddLocation({Key key, this.lat, this.lng}) : super(key: key);
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  // Field
  double lat, lng;
  CameraPosition cameraPosition;
  LatLng latLng;
  File file;
  String name, detail, pathImage, dateString;

  // Method
  @override
  void initState() {
    super.initState();
    // findLatLng();

    setState(() {
      lat = widget.lat;
      lng = widget.lng;
      print('latlng on AddLocaatinn ===>> $lat, $lng');
    });
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat, lng on add Locaton ===>>>$lat, $lng');
    });
  }

  Future<LocationData> findLocationData() async {
    var location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      print('e AddLocation ==>> ${e.toString()}');
      return null;
    }
  }

  Set<Marker> mySetMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('myId'),
          position: latLng,
          infoWindow: InfoWindow(
            title: 'ตำแหน่งของคุณ',
            snippet: 'ละติจูด = $lat, ลองติจูต = $lng',
          )),
    ].toSet();
  }

  Widget showMap() {
    if (lat != null) {
      latLng = LatLng(lat, lng);
      cameraPosition = CameraPosition(
        target: latLng,
        zoom: 16.0,
      );
    }

    return Container(
      margin: EdgeInsets.all(24.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: lat == null
          ? MyStyle().showPrograss()
          : GoogleMap(
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              onMapCreated: (value) {},
              markers: mySetMarker(),
            ),
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              onChanged: (value) => name = value.trim(),
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
              onChanged: (value) => detail = value.trim(),
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
    return Scaffold(
      floatingActionButton: uploadButton(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().showTitle('Avatar Image'),
            showImage(),
            MyStyle().showTitle('Information'),
            nameForm(),
            detailForm(),
            showDate(),
            MyStyle().showTitle('Your Location'),
            showMap(),
          ],
        ),
      ),
    );
  }

  Row showDate() {
    DateTime dateTime = DateTime.now();
    dateString = DateFormat('dd-MM-yyyy').format(dateTime);

    return Row(
      children: <Widget>[
        MyStyle().showTitle('Date Record : '),
        Text(dateString)
      ],
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      child: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'No Image', 'Please Tap on Camera or Gallery');
        } else if (name == null ||
            name.isEmpty ||
            detail == null ||
            detail.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          uploadImage();
        }
      },
    );
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(10000);
    String nameImage = 'image$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Image/$nameImage');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    pathImage = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('pathImage = $pathImage');

    insertDataToFirestore();
  }

  Future<Null> insertDataToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    String uid = firebaseUser.uid;

    Map<String, dynamic> map = Map();
    map['DateTime'] = dateString;
    map['Detail'] = detail;
    map['Lat'] = lat;
    map['Lng'] = lng;
    map['Name'] = name;
    map['PathImage'] = pathImage;
    map['Uid'] = uid;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection('MarkerCollect');
    await collectionReference.document().setData(map).then((value) {
      print('Upload Success');

      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => MyService(),
      );
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker.pickImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget showImage() => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () => chooseImage(ImageSource.camera)),
            file == null
                ? Image.asset('images/avatar.png')
                : Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Image.file(file),
                  ),
            IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: () => chooseImage(ImageSource.gallery)),
          ],
        ),
      );
}
