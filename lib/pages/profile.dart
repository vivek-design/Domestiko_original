import 'dart:io';

import 'package:domestiko/Utilities/col.dart';
import 'package:domestiko/Utilities/global.dart';
import 'package:domestiko/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image;

  var role;
  var username;
  var email;
  var phone;
  var age;
  var gender;
  @override
  void initState() {
    super.initState();
    getuserdata();
    del();
  }

  Future<void> del() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: del(),
      builder: (context,  snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                child: Column(children: [
                  Container(
                    height: 500,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/clock.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 210,
                            top: 200,
                            width: 130,
                            height: 200,
                            child: Container(
                                child: (CircleAvatar(
                              radius: 58,
                              backgroundImage: AssetImage(
                                  'assets/images/WhatsApp Image 2022-06-16 at 12.03.50 PM (1).jpeg'),
                              child: Stack(children: [
                                Positioned(
                                  top: 120,
                                  left: 90,
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white70,
                                        child: Icon(CupertinoIcons.camera),
                                      ),
                                      onTap: () {
                                        pickImage();
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            )))),
                      ],
                    ),
                  ),
                  Container(
                    //all the remaining profile options

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            "Role:   $role",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            "Username:  $username",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            "Email: $email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            "Phone:   $phone",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 200, 0),
                          child: Text(
                            "Age:   $age",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 200, 0),
                          child: Text(
                            "Gender:   $gender",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: Lottie.network(
                "https://assets2.lottiefiles.com/private_files/lf30_ixykrp0i.json",
                repeat: true,
                height: 150,
                width:150,
              )
            ),
          );
        }
      },
    );
  }

  Future<bool> getuserdata() async {
    bool result = false;
    DatabaseReference databaseRefu = FirebaseDatabase.instance.ref('User');
    final user = Auth().currentUser;
    var dataSnapshot;

    await databaseRefu.child(user!.uid).once().then((Event) {
      dataSnapshot = Event.snapshot.exists;
    });

    if (dataSnapshot != null) {
      role = "User";
      Stream<DatabaseEvent> stream = databaseRefu.onValue;
      stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        Map<Object?, Object?> map1 = event.snapshot.value as Map;

        print(map1[user.uid]);
        Map mp2 = map1[user.uid] as Map;
        username = mp2['Name'];
        email = mp2['Email'];
        age = mp2['Age'];
        gender = mp2['gender'];
        phone = mp2['Phone'];

        result = true;
      });
    } else {
      print(user.uid);
      role = "Maid";
      DatabaseReference maidref = FirebaseDatabase.instance.ref('Maid');
      maidref.child(user.uid);
      Stream<DatabaseEvent> stream = maidref.onValue;
      await stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        // print('Snapshot: ${(event.snapshot.value as Map)["cost"]}');

        Map<Object?, Object?> map1 = event.snapshot.value as Map;
        print(map1);

        Map mp2 = map1[user.uid] as Map;
        username = mp2['Name'];
        email = mp2['Email'];
        age = mp2['Age'];
        gender = mp2['gender'];
        phone = mp2['Phone'];
        result = true;
      });
    }

    return result;
  }
}
