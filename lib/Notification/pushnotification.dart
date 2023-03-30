import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:math';

import 'package:domestiko/Notification/jobdialog.dart';
import 'package:domestiko/Utilities/retriveorderdetail.dart';
import 'package:domestiko/pages/alertbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class pushnotificationservice {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //retrive job id from the message
  String getjobid(RemoteMessage message) {
    String job_id;
    if (Platform.isAndroid) {
      job_id = message.data['job_request_id'];
    } else {
      job_id = message.data['job_request_id'];
    }

    return job_id;
  }

//retrive maid info from the message job id

  void retrieve_maid_data(job_id, BuildContext context) {
    if (job_id != null) {
      final assetsAudioPlayer = AssetsAudioPlayer();
      assetsAudioPlayer.open(Audio("sounds/notification_sound.mp3"));
      assetsAudioPlayer.play();
      DatabaseReference reqref = FirebaseDatabase.instance.ref('Request');
      DatabaseReference userref = FirebaseDatabase.instance.ref('User');

      var cost, lati, time, longi, tim, name, phone;

      //for request info gatherign
      reqref.child(job_id);
      Stream<DatabaseEvent> stream = reqref.onValue;

      stream.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        // print('Snapshot: ${(event.snapshot.value as Map)["cost"]}');

        Map<Object?, Object?> map1 = event.snapshot.value as Map;

        print(map1[job_id]);
        Map mp2 = map1[job_id] as Map;
        cost = mp2['cost'];
        lati = mp2['latitude'];
        time = mp2['time'];
        longi = mp2['longitude'];
      });

      userref.child(job_id);
      Stream<DatabaseEvent> stream2 = userref.onValue;

      stream2.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;

        // print('Snapshot: ${(event.snapshot.value as Map)["cost"]}');

        Map<Object?, Object?> map1 = event.snapshot.value as Map;

        print(map1[job_id]);
        Map mp2 = map1[job_id] as Map;
        name = mp2['Name'];
        phone = mp2['Phone'];

        maiddetail Detail =
            maiddetail(cost, time, name, phone, lati, longi, job_id);
        print(Detail.name);
        print(Detail.phone);
        print(Detail.time);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => job_dialog(Maiddetail: Detail));
      });
      assetsAudioPlayer.stop();
    }
  }

  //getToken

  void getToken(BuildContext context) async {
    var settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied ||
        settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      print("chud");
      getToken(context);
    } else {
      String? token = await messaging.getToken();
      print('Your token is $token');
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Maid');
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        databaseRef.child(user.uid).child("token").set(token);
        messaging.subscribeToTopic("allmaid");
        messaging.subscribeToTopic("allusers");

        
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          //  String jobid = getjobid(message);

          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');

          if (message.notification != null) {
            print(
                'Message also contained a notification: ${message.notification}');
          }

          var id = message.data['job_request_id'];
          retrieve_maid_data(id, context);
        });
      }
    }
  }
}
