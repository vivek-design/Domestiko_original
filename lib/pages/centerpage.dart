import 'dart:async';
import 'dart:ffi';
import 'dart:math' show cos, sqrt, asin;
// import 'package:permission/permission.dart';
import 'package:domestiko/Utilities/Drawer.dart';
import 'package:domestiko/Utilities/GeofireAssistant.dart';
import 'package:domestiko/Utilities/Routes.dart';
import 'package:domestiko/Utilities/col.dart';
import 'package:domestiko/Utilities/nearby.dart';
import 'package:domestiko/Notification/pushnotification.dart';
import 'package:domestiko/pages/accepted_foruser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../Utilities/bottomshet.dart';
import '../main.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:flutter/material.dart';

class Central extends StatefulWidget {
  const Central({super.key});

  @override
  State<Central> createState() => _CentralState();
}

class _CentralState extends State<Central> {
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

    initGeoFIreListner();
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
  void initGeoFIreListner() {
    Geofire.initialize("availableMaid");
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 5)
        ?.listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyMaid nearbymaid =
                NearbyMaid(map['key'], map['latitude'], map['longitude']);
            GeoFireAssistant.nearbyMaidList.add(nearbymaid);
            updateavailablemaidonmap();

            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removemaidformlist(map['key']);
            updateavailablemaidonmap();

            break;

          case Geofire.onKeyMoved:
            NearbyMaid nearbymaid =
                NearbyMaid(map['key'], map['latitude'], map['longitude']);
            GeoFireAssistant.updatemaidinList(nearbymaid);
            // Update your key's location
            updateavailablemaidonmap();

            break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            // print(map['result'])
            updateavailablemaidonmap();

            break;
        }
      }

      setState(() {});
    });
  }

//locate nearby available maid on the map

  void createIconMarker() {
    ImageConfiguration imageConfiguration =
        //******************************************************************** size into the argument check for it  */
        createLocalImageConfiguration(
      context,
    );
    BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/images/neq.png')
        .then((value) {
      nearbyIcon = value;
    });
  }

//update avialable maid on map

  void updateavailablemaidonmap() {
    setState(() {
      markerset.clear();
    });

    Set<Marker> tmarkers = Set<Marker>();

    for (NearbyMaid maid in GeoFireAssistant.nearbyMaidList) {
      LatLng maidpos = LatLng(maid.latitude, maid.longitude);

      Marker marker = Marker(
        markerId: MarkerId('maid${maid.key}'),
        position: maidpos,
        icon: nearbyIcon,
        rotation: GeoFireAssistant.createRandomNumber(360),
      );
      tmarkers.add(marker);
    }

    setState(() {
      markerset = tmarkers;
    });
  }

  // void getpush() {
  //   pushnotificationservice push = pushnotificationservice();
  //   push.getToken();
  // }

  void delref() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance.ref('Maid');
      db.child(user.uid).remove();
    }
  }

  @override
  void initState() {
    super.initState();
    // getpush();
    getJsonFile("assets/images/mapstyle.json").then((temp) {
      _mapStyle = temp;
    });
    delref();
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

  var _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();
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
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 140,
              top: 470,
              child: OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 400,
                          child: popupcontain(),
                        );
                      });
                },
                child: Text(
                  'Hire',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                    backgroundColor: rang.always),
              ))
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
           
            Navigator.pushNamed(context, router.History);
             
             setState(() {
               index = 1;
             });
          }

          if (index == 2) {
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushNamed(context, router.Setting);
             index = 1;
             setState(() {
               index = 1;
             });
          }
        },
      ),
      drawer: myDrawer(),
    );
  }
}

class popupcontain extends StatefulWidget {
  const popupcontain({super.key});

  @override
  State<popupcontain> createState() => _popupcontainState();
}

class _popupcontainState extends State<popupcontain> {
  Color for1 = Colors.white;
  Color for2 = Colors.white;
  Color for3 = Colors.white;
  late List<NearbyMaid> avialablemaid;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          InkWell(
            onTap: () {
              setState(() {
                for3 = Colors.white;
                for2 = Colors.white;
                for1 = rang.always;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: for1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      "assets/images/4567e7e287816c6c9e2160ea4fbaa3a9.jpg"),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "For  30 min. of work",
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  )),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  "Rs. 200/-",
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  )),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              setState(() {
                for1 = Colors.white;
                for3 = Colors.white;
                for2 = rang.always;
                ;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: for2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      "assets/images/WhatsApp Image 2023-01-15 at 23.35.43.jpeg"),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "For 1 hr of work ",
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  )),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  "Rs. 400/-",
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  )),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              setState(() {
                for1 = Colors.white;
                for2 = Colors.white;
                for3 = rang.always;
                ;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: for3, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      "assets/images/WhatsApp Image 2023-01-15 at 23.36.27.jpeg"),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "For 2 hr of work",
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  )),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  "Rs. 500/-",
                  style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  )),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          InkWell(
            onTap: () async {
              avialablemaid = GeoFireAssistant.nearbyMaidList;

              if (for1 == rang.always ||
                  for2 == rang.always ||
                  for3 == rang.always) {
                final User = FirebaseAuth.instance.currentUser;

                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                int price = 0;
                int time = 0;
                if (for1 == rang.always) {
                  price = 200;
                  time = 30;
                } else if (for2 == rang.always) {
                  price = 400;
                  time = 60;
                } else {
                  price = 500;
                  time = 120;
                }

                DatabaseReference databaseR =
                    FirebaseDatabase.instance.ref('Request');
                if (User != null) {
                  databaseR.child(User.uid).set({
                    'latitude': position.latitude,
                    'longitude': position.longitude,
                    'request_id': User.uid,
                    'cost': price,
                    'time': time,
                    'status': 'searching'
                  });

                  serchNearbyMaid(context);
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Please select one of the above plans");
              }
            },
            child: Ink(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: rang.always,
              ),
              child: Center(
                child: Text("Engage",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ]));
  }

  void serchNearbyMaid(BuildContext context) {
    if (avialablemaid.length == 0) {
      Navigator.pop(context);
      Navigator.pushNamed(context, router.Nomaidavail);
    } else {
      var maide = avialablemaid[0];
      avialablemaid.removeAt(0);
      notifyMaid(maide, context);
    }
  }

  void notifyMaid(NearbyMaid maide, BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Maid");
    ref.child(maide.key);
//checking if the current available maid is ready to accept the order
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;

      Map<Object?, Object?> map1 = event.snapshot.value as Map;
      print(map1);

      Map mp2 = map1[maide.key] as Map;
      String? tokenn = mp2['token'].toString();
      String Sta = mp2['status'];
      if (Sta == 'engaged') {
        //if Not then just search for another one
        return serchNearbyMaid(context);
      }

      //if the maid is available to accept the order

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        GeoFireAssistant.sendNotification(tokenn, context, user.uid.toString());

        print(tokenn);

        int timeout = 20;

        //checking for timeout
        DatabaseReference reqref;
        reqref = FirebaseDatabase.instance.ref('Request').child(user.uid);
        const oneSecondPassed = Duration(seconds: 1);
        var timer = Timer.periodic(oneSecondPassed, (timer) {
          print("enterd here");
          reqref.child("status").onValue.listen((event) {
            if (event.snapshot.value.toString() == "accepted") {
              timeout = 20;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Userrequestfound(
                    maid_id: maide.key,
                  ),
                ),
              );
              timer.cancel();
            }

            if (event.snapshot.value.toString() == 'cancelled') {
              timeout = 20;
              timer.cancel();
              serchNearbyMaid(context);
            }
          });
          timeout = timeout - 1;
          if (timeout <= 0) {
            timeout = 20;

            serchNearbyMaid(context);
          }
        });
      }
    });
  }
}
