// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:domestiko/Utilities/Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:domestiko/Utilities/retriveorderdetail.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/AcceptedPage.dart';

class job_dialog extends StatelessWidget {
  final maiddetail Maiddetail;
  const job_dialog({required this.Maiddetail});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      elevation: 1.0,
      //  alignment: AlignmentDirectional.center,

      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        height: 530,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(children: [
          SizedBox(
            height: 20.0,
          ),
          Image.asset(
            "assets/images/WhatsApp Image 2023-01-15 at 23.35.43.jpeg",
            width: 120.0,
            height: 100,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "New job request",
            style: TextStyle(
                fontFamily: "Brand-Bold",
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/2775994.png",
                height: 50.0,
                width: 40.0,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Customer Name  ${Maiddetail.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // child:
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/2775994.png",
                height: 50.0,
                width: 40.0,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Job location ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // child:
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/2775994.png",
                height: 50.0,
                width: 40.0,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Phone      ${Maiddetail.phone}   ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // child:
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/2775994.png",
                height: 50.0,
                width: 40.0,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Pay         RS. ${Maiddetail.cost}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // child:
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/images/2775994.png",
                height: 50.0,
                width: 40.0,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Work min        ${Maiddetail.time}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // child:
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Divider(),
          SizedBox(
            height: 8.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  DatabaseReference reqref = FirebaseDatabase.instance
                      .ref('Request')
                      .child(Maiddetail.job_id);
                  if (reqref != null) {
                    Navigator.pop(context);

                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      DatabaseReference databaseReference =
                          FirebaseDatabase.instance.ref('Maid');
                      databaseReference
                          .child(user.uid)
                          .set({'status': "engaged"});

                      reqref.set({'status': "accepted"});
                    }
                    reqref.remove();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => accepted_page(
                          Readme: Maiddetail,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "This request is no longer available ");
                  }
                },
                child: Container(
                  height: 50,
                  width: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(143, 148, 251, 1),
                        Color.fromRGBO(143, 148, 251, 6),
                      ])),
                  child: Center(
                    child: Text("Accept",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                    DatabaseReference reqref = FirebaseDatabase.instance
                      .ref('Request')
                      .child(Maiddetail.job_id);

                       reqref.set({'status': "cancelled"});
                },
                child: Container(
                  height: 50,
                  width: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(143, 148, 251, 1),
                        Color.fromRGBO(143, 148, 251, 6),
                      ])),
                  child: Center(
                    child: Text("Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
