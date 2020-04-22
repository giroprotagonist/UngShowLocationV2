import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  Widget currentWidget = ShowMap();

  // Method
  @override
  void initState() {
    super.initState();

    var object = widget.currentWidget;
    if (object != null) {
      setState(() {
        currentWidget = object;
      });
    }
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
          currentWidget = ShowMap();
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
          currentWidget = AddLocation();
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
    return UserAccountsDrawerHeader(
      currentAccountPicture: Image.asset('images/police.png'),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text('Name'),
      accountEmail: Text('Email'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(),
      appBar: AppBar(
        title: Text('My Service'),
      ),
      body: currentWidget,
    );
  }
}
