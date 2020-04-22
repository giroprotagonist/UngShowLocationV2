import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ungshowlocation/widget/add_location.dart';
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

  // Method

  @override
  void initState() {
    super.initState();
    // findLatLng();
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
    return <Marker>[
      localMarker(),
      busStopMarker(),
      policeMarker(),
    ].toSet();
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
        addButton(),
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
                            currentWidget: AddLocation(),
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
