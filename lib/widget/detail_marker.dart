import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungshowlocation/models/marker_collect_model.dart';
import 'package:ungshowlocation/models/user_model.dart';
import 'package:ungshowlocation/utility/my_style.dart';

class DetailMarker extends StatefulWidget {
  final MarkerCollectModel model;
  final String nameDocument;
  DetailMarker({Key key, this.model, this.nameDocument}) : super(key: key);

  @override
  _DetailMarkerState createState() => _DetailMarkerState();
}

class _DetailMarkerState extends State<DetailMarker> {
  MarkerCollectModel model;
  UserModel userModel;
  String editName, nameDocument;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    nameDocument = widget.nameDocument;
    print('namedocu ===>>> $nameDocument');
    findUser();
  }

  Future<Null> findUser() async {
    print('uid ===>> ${model.uid}');
    Firestore firestore = Firestore.instance;
    CollectionReference reference = firestore.collection('UserCollect');
    reference.document(model.uid).snapshots().listen((event) {
      var map = event.data;
      setState(() {
        userModel = UserModel.fromJSON(map);
        print('NameRec ====>>> ${userModel.name}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showName(),
            showImage(),
            showDetail(),
            showDate(),
            showLocation(context),
            showRecord(),
          ],
        ),
      ),
    );
  }

  Text showRecord() =>
      Text(userModel == null ? 'Name Recored' : userModel.name);

  Container showLocation(BuildContext context) {
    LatLng latLng = LatLng(model.lat, model.lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.satellite,
        onMapCreated: (controller) {},
        markers: mySetMarker(),
      ),
    );
  }

  Set<Marker> mySetMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('idMar'),
          position: LatLng(model.lat, model.lng),
          infoWindow: InfoWindow(title: model.name, snippet: model.dateTime))
    ].toSet();
  }

  Widget showDate() => MyStyle().showTitle(model.dateTime);

  Widget showDetail() => MyStyle().showTitle(model.detail);

  Widget showImage() => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Image.network(model.pathImage),
      );

  Future<Null> confirmEditName() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: TextFormField(
          onChanged: (value) => editName = value.trim(),
          initialValue: model.name,
        ),
        children: <Widget>[
        ],
      ),
    );
  }

  Widget showName() {
    return ListTile(
      title: MyStyle().showTitle(model.name),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => confirmEditName(),
      ),
    );
  }
}
