import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:domestiko/Utilities/col.dart';
import '../Utilities/GeofireAssistant.dart';
import '../Utilities/nearby.dart';

class Userrequestfound extends StatefulWidget {
String maid_id;
  
   Userrequestfound({super.key, required this.maid_id});

  @override
  State<Userrequestfound> createState() => _UserrequestfoundState();
}

class _UserrequestfoundState extends State<Userrequestfound> {
  String? _mapStyle;
  late Position currentPosition;
  var geoLocator = Geolocator();
  @override
  Set<Marker> markerset = {};
  late BitmapDescriptor nearbyIcon;

  //initial position on map;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

//map style
  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

//  get current location

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
    currentPosition = position;

    LatLng latLatposition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatposition, zoom: 17);
    mycontroller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

//  get current location

//locate nearby available maid on the map
//
//
//
//
//
//
//
//
//
//
  // void getpush() {
  //   pushnotificationservice push = pushnotificationservice();
  //   push.getToken();
  // }




  List<LatLng> polylineCoordinates = [];
  void displayroute(Position source) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD1i_YaHQniH-Hpneo3gFPOchN40MPeAp8',
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(23.117123, 75.814828),
    );

    print(result.points);
    if (result.points.isNotEmpty) {
      print("INT=");
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
    

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // getpush();
    getJsonFile("assets/images/mapstyle.json").then((temp) {
      _mapStyle = temp;
    });
  }

  GoogleMapController? mycontroller;

  var _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
//         //we want this theme to be applicable in every place of app then we have
//         //appbaar theme which we can use to add in the main file which will implement
//         //on all the appbas
        backgroundColor: rang.always,
//         // // it will remove the partition line
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Center(
            child: Text(
              "Domestico",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
              markers: markerset,
               polylines: {
                Polyline(
                    polylineId: PolylineId("route"),
                    points: polylineCoordinates)
              },
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "your maid is reaching",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              top: 400,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black)),
                width: 365,
                height: 300,
                child: Row(children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Maid Name :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Age :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Phone No :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Job time :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          " Payment Mode : Cash ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: rang.always,
                                        borderRadius:
                                            (BorderRadius.circular(10))),
                                    child: Center(
                                      child: Text("Cancel Job",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                  'assets/images/WhatsApp Image 2022-06-16 at 12.03.50 PM (1).jpeg'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ))
        ],
      ),
    );
  }
}
