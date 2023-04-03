import 'dart:async';

import 'dart:math' show cos, sqrt, asin;
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:domestiko/Utilities/Drawer.dart';
import 'package:domestiko/Utilities/Routes.dart';
import 'package:domestiko/Utilities/col.dart';
import 'package:domestiko/Notification/pushnotification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';
import '../Utilities/circularpro.dart';
import '../auth.dart';
import '../main.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:flutter/material.dart';

class maidpage extends StatefulWidget {
  const maidpage({super.key});

  @override
  State<maidpage> createState() => _maidpageState();
}

class _maidpageState extends State<maidpage> {
  @override
  String? _mapStyle;

  @override
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  var _selectedIndex = 1;

  void locateposition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var currentPosition = position;

    LatLng latLatposition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatposition, zoom: 17);
    mycontroller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    getJsonFile("assets/images/mapstyle.json").then((temp) {
      _mapStyle = temp;
    });

    Permission.camera.request();
    Permission.microphone.request();

    Permission.sms.request();
    notificationcheck();
    onlinestatuscheck();
    // getUser();
  }

  void getUser() async {
    DatabaseReference databaseRefu = FirebaseDatabase.instance.ref('User');
    final user = Auth().currentUser;
    var dataSnapshot;

    await databaseRefu.child(user!.uid).once().then((Event) {
      dataSnapshot = Event.snapshot.exists;
    });

    if (dataSnapshot != null) {
      Userdet.role = "User";
      Stream<DatabaseEvent> stream = databaseRefu.onValue;
      stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        Map<Object?, Object?> map1 = event.snapshot.value as Map;

        print(map1[user.uid]);
        Map mp2 = map1[user.uid] as Map;
        Userdet.name = mp2['Name'];
        Userdet.email = mp2['Email'];
        Userdet.age = mp2['Age'];
        Userdet.gender = mp2['gender'];
        Userdet.Phone = mp2['Phone'];
      });
    } else {
      print(user.uid);
      Userdet.role = "Maid";
      DatabaseReference maidref = FirebaseDatabase.instance.ref('Maid');
      maidref.child(user.uid);
      Stream<DatabaseEvent> stream = maidref.onValue;
      await stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        // print('Snapshot: ${(event.snapshot.value as Map)["cost"]}');

        Map<Object?, Object?> map1 = event.snapshot.value as Map;
        print(map1);

        Map mp2 = map1[user.uid] as Map;
        Userdet.name = mp2['Name'];
        Userdet.email = mp2['Email'];
        Userdet.age = mp2['Age'];
        Userdet.gender = mp2['gender'];
        Userdet.Phone = mp2['Phone'];
      });
    }
  }

  bool status = false;
  var hell = "Offline";
  Color mycc = Colors.red;

  // Future<String> dele() async {
  //   await Future.delayed();
  // }

  Future<bool> onlinestatuscheck() async {
    final user = FirebaseAuth.instance.currentUser;

    DatabaseReference maidref = FirebaseDatabase.instance.ref('Maid');
    if (user != null) {
      maidref.child(user.uid);
      Stream<DatabaseEvent> stream = maidref.onValue;
      await stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        // print('Snapshot: ${(event.snapshot.value as Map)["cost"]}');

        Map<Object?, Object?> map1 = event.snapshot.value as Map;
        print(map1);

        Map mp2 = map1[user.uid] as Map;

        if (mp2['status'] == "DND") {
          status = false;
          hell = "Offline";
          mycc = Colors.red;
        } else {
          status = true;
          hell = "Online";
          mycc = Colors.green;
        }
      });
    }
  await  Future.delayed(Duration(seconds: 3));
    return true;
  }

  void notificationcheck() {
    pushnotificationservice notification = pushnotificationservice();
    notification.getToken(context);
  }

  GoogleMapController? mycontroller;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onlinestatuscheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print(1);
          print(snapshot.connectionState);
          return circularindi();
        } else if (snapshot.connectionState == ConnectionState.done) {
          print(status);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 200,

//         //we want this theme to be applicable in every place of app then we have
//         //appbaar theme which we can use to add in the main file which will implement
//         //on all the appbas
              backgroundColor: rang.always,
//         // // it will remove the partition line
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Text(
                          "Domestico",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          "Active status",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(60, 20, 10, 10),
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                child: CircleAvatar(
                                  radius: 6,
                                  foregroundColor: mycc,
                                  backgroundColor: mycc,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "$hell",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: CupertinoSwitch(
                                  thumbColor: Colors.white,
                                  trackColor: Colors.black,
                                  activeColor: Colors.black,
                                  value: status,
                                  onChanged: (value) {
                                    setState(() {
                                      status = value;
                                      if (status == false) {
                                        hell = "Offline";
                                        mycc = Colors.red;
                                        makemaidoffline();
                                      } else {
                                        hell = "Online";
                                        mycc = Colors.green;
                                        makemaidonline();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      mycontroller = controller;
                      mycontroller?.setMapStyle(_mapStyle);
                      locateposition();
                    },
                  ),
                ),
                Positioned(
                    left: 100,
                    top: 10,
                    child: Container(
                        child: Row(
                      children: [
                        Container(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/WhatsApp Image 2022-06-16 at 12.03.50 PM (1).jpeg"),
                            radius: 35,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Hey there!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "How you doing?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )))
              ],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: rang.always,
              backgroundColor: Colors.white,
              index: 1,
              items: [
                Icon(Icons.history),
                Icon(Icons.home),
                Icon(Icons.settings),
              ],
              onTap: (index) async {
                if (index == 0) {
                  await Future.delayed(const Duration(seconds: 1));
                  index = 1;
                  Navigator.pushNamed(context, router.History);
                  setState(() {});
                }

                if (index == 2) {
                  await Future.delayed(const Duration(seconds: 1));
                  index = 1;
                  Navigator.pushNamed(context, router.Setting);
                  setState(() {});
                }
              },
            ),
            drawer: myDrawer(),
          );
        } else {
          print(snapshot.connectionState);
          return circularindi();
        }
      },
    );
  }

  void makemaidonline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Geofire.initialize("availableMaid");
    var user = FirebaseAuth.instance.currentUser;
    Geofire.setLocation(user!.uid, position.latitude, position.longitude);

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('Maid');
    databaseReference.child(user.uid).update({"status": "searching"});
  }

  void makemaidoffline() {
    var user = FirebaseAuth.instance.currentUser;
    Geofire.removeLocation(user!.uid);

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('Maid');
    databaseReference.child(user.uid).update({"status": "DND"});
  }
}
