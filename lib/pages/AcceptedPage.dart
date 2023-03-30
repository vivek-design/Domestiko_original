// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:domestiko/Utilities/Routes.dart';
import 'package:domestiko/Utilities/col.dart';

import '../Notification/pushnotification.dart';
import '../Utilities/Drawer.dart';
import '../Utilities/retriveorderdetail.dart';

class accepted_page extends StatefulWidget {
  maiddetail Readme;
  accepted_page({
    Key? key,
    required this.Readme,
  }) : super(key: key);

  @override
  State<accepted_page> createState() => _accepted_pageState();
}

class _accepted_pageState extends State<accepted_page> {
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

  var _selectedIndex = 0;

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
    displayroute(position);

    LatLng latLatposition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatposition, zoom: 17);
    mycontroller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

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

    getJsonFile("assets/images/mapstyle.json").then((temp) {
      _mapStyle = temp;
    });
  }

  GoogleMapController? mycontroller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,

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
                    "job destination",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
              ))),
          Positioned(
              top: 500,
              left: 150,
              child: InkWell(
                onTap: () => {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 300,
                          width: 200,
                          child: showcontain(),
                        );
                      })
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    CupertinoIcons.arrow_2_squarepath,
                    size: 30,
                    color: rang.always,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class showcontain extends StatefulWidget {
  const showcontain({super.key});

  @override
  State<showcontain> createState() => _showcontainState();
}

class _showcontainState extends State<showcontain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("Customer Name :"),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text("Address:"),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text("Phone :"),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text("Pay: "),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
               User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      DatabaseReference databaseReference =
                          FirebaseDatabase.instance.ref('Maid');
                      databaseReference
                          .child(user.uid)
                          .set({'status': "serching"});
                    }
              Navigator.pushNamedAndRemoveUntil(
                  context, router.maid, (route) => false);
            },
            child: Ink(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: rang.always,
              ),
              child: Center(
                child: Text("Cancel Job",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
