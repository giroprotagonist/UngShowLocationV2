import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ungshowlocation/utility/my_style.dart';
import 'package:ungshowlocation/widget/add_location.dart';
import 'package:ungshowlocation/widget/main_home.dart';
import 'package:ungshowlocation/widget/show_map.dart';

class MyService extends StatefulWidget {
  final Widget currentWidget;
  MyService({Key key, this.currentWidget}) : super(key: key);
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  Widget currentWidget;
  String name, email, urlAvatar;
  double lat, lng;

  // Method
  @override
  void initState() {
    super.initState();

    findLatLng();

    findNameAnAvatar();

    var object = widget.currentWidget;
    if (object != null) {
      setState(() {
        currentWidget = object;
      });
    }
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat =>>> $lat, lng ===>> $lng');
      currentWidget = ShowMap(
        lat: lat,
        lng: lng,
      );
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

  Future<void> findNameAnAvatar() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    setState(() {
      name = firebaseUser.displayName;
      email = firebaseUser.email;
      urlAvatar = firebaseUser.photoUrl;
    });
  }

  Widget myDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          menuShowMap(),
          menuShowAdd(),
          menuSignOut(),
        ],
      ),
    );
  }

  ListTile menuShowMap() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowMap(lat: lat,lng: lng,);
        });
        Navigator.of(context).pop();
      },
      leading: Icon(
        Icons.language,
        size: 36.0,
        color: MyStyle().darkColor,
      ),
      title: Text('Show Map'),
      subtitle: Text('Descrip Page Show Map and Location'),
    );
  }

  ListTile menuShowAdd() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = AddLocation(
            lat: lat,
            lng: lng,
          );
        });
        Navigator.of(context).pop();
      },
      leading: Icon(
        Icons.local_airport,
        size: 36.0,
        color: MyStyle().darkColor,
      ),
      title: Text('Add Location'),
      subtitle: Text('Descrip Page Show Add Location'),
    );
  }

  ListTile menuSignOut() {
    return ListTile(
      onTap: () {
        signOutProcess();
      },
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: MyStyle().darkColor,
      ),
      title: Text('Sign Out'),
      subtitle: Text('Sign Out and Back to Authen'),
    );
  }

  Future<void> signOutProcess() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((response) {
      MaterialPageRoute route =
          MaterialPageRoute(builder: (value) => MainHome());
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
  }

  UserAccountsDrawerHeader showHead() {
    if (name == null) {
      name = '';
    } else if (email == null) {
      email = '';
    }
    if (urlAvatar == null) {
      urlAvatar =
          'https://firebasestorage.googleapis.com/v0/b/ungshowlocation.appspot.com/o/Avatar%2Favatar.png?alt=media&token=5525d38c-9ba7-4579-ab31-ec4700671355';
    }
    return UserAccountsDrawerHeader(
      currentAccountPicture: Image.network(urlAvatar),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text('$name Login'),
      accountEmail: Text('$email'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          title: Text('My Service'),
        ),
        body: currentWidget == null ? MyStyle().showPrograss() : currentWidget);
  }
}
