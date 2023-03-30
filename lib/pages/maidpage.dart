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
  }

  void notificationcheck() {
    pushnotificationservice notification = pushnotificationservice();
    notification.getToken(context);
  }

  bool status = false;
  var hell = "Offline";
  Color mycc = Colors.red;

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
            setState(() {
              
            });
          }

          if (index == 2) {
            await Future.delayed(const Duration(seconds: 1));
            index = 1;
            Navigator.pushNamed(context, router.Setting);
            setState(() {
              
            });
          }
        },
      ),
      drawer: myDrawer(),
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
  }
}
