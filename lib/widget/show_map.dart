import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ungshowlocation/models/marker_collect_model.dart';
import 'package:ungshowlocation/widget/add_location.dart';
import 'package:ungshowlocation/widget/detail_marker.dart';
import 'package:ungshowlocation/widget/my_service.dart';

class ShowMap extends StatefulWidget {
  final double lat;
  final double lng;
  ShowMap({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  // Field
  double lat, lng;
  BitmapDescriptor policeIcon;
  List<Marker> list = List();
  List<String> listDocuments = List(); 

  // Method

  @override
  void initState() {
    super.initState();
    // findLatLng();

    readDataFromFirebase();

    setState(() {
      lat = widget.lat;
      lng = widget.lng;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'images/police2.png')
        .then((value) {
      policeIcon = value;
    });
  }

  Future<Null> readDataFromFirebase() async {
    print('###############readDataFromFirebase Work####################');

    // list = [
    //   localMarker(),
    //   busStopMarker(),
    //   policeMarker(),
    // ];

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection('MarkerCollect');
    collectionReference.snapshots().listen((event) {
      List<DocumentSnapshot> snapshots = event.documents;
      for (var map in snapshots) {
        MarkerCollectModel model = MarkerCollectModel.fromMap(map.data);
        String nameDocument = map.documentID;
        listDocuments.add(nameDocument);
        print('Name ==>> ${model.name}');
        Marker marker = createMarker(model, nameDocument);
        setState(() {
          list.add(marker);
          print('myMarkers set lenght ==>> ${myMarkers().length}');
        });
      }
    });
  }

  Marker createMarker(MarkerCollectModel markerCollectModel, String nameDocument) {
    Marker marker;
    Random random = Random();
    int i = random.nextInt(100);
    String idString = 'id$i';

    marker = Marker(
      markerId: MarkerId(idString),
      position: LatLng(markerCollectModel.lat, markerCollectModel.lng),
      infoWindow: InfoWindow(
          title: markerCollectModel.name, snippet: markerCollectModel.detail),
      onTap: () {
        print('You Tab Name ==>> ${markerCollectModel.name}');

        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => DetailMarker(
            model: markerCollectModel,nameDocument: nameDocument,
          ),
        );
        Navigator.push(context, route);
      },
    );
    return marker;
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat =>>> $lat, lng ===>> $lng');
    });
  }

  Future<LocationData> findLocation() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('e location = ${e.toString()}');
      return null;
    }
  }

  Marker policeMarker() {
    return Marker(
      icon: policeIcon,
      markerId: MarkerId('home'),
      position: LatLng(13.666749, 100.619768),
      infoWindow: InfoWindow(
        title: 'Police Station',
        snippet: 'This is Police',
      ),
    );
  }

  Set<Marker> myMarkers() {
    list.add(busStopMarker());
    list.add(localMarker());
    list.add(policeMarker());
    return list.toSet();
  }

  Marker localMarker() {
    return Marker(
      infoWindow: InfoWindow(
        title: 'You are here ?',
        snippet: 'lat = $lat, lng = $lng',
      ),
      markerId: MarkerId('myLocotion'),
      position: LatLng(lat, lng),
    );
  }

  Marker busStopMarker() {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(80.0),
      markerId: MarkerId('busStop'),
      position: LatLng(13.670002, 100.623416),
      infoWindow: InfoWindow(
        title: 'ป้ายรถเมย์',
        snippet: 'ป้ายรถเมย์ หน้าหมู่บ้าน',
      ),
    );
  }

  Widget showMap() {
    // lat = 13.680218;
    // lng = 100.587582;
    print('latlng on showmap ===>>> $lat, $lng');
    LatLng centerLatLng = LatLng(lat, lng);
    CameraPosition cameraPosition =
        CameraPosition(target: centerLatLng, zoom: 16.0);

    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          markers: myMarkers(),
          onMapCreated: (value) {},
        ),
        // addButton(),
      ],
    );
  }

  Widget addButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 40.0,
                bottom: 40.0,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (value) => MyService(
                            currentWidget: AddLocation(
                              lat: lat,
                              lng: lng,
                            ),
                          ));
                  Navigator.of(context)
                      .pushAndRemoveUntil(route, (value) => false);
                },
                child: Icon(
                  Icons.add_circle,
                  size: 36.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lat == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : showMap(),
    );
  }
}
