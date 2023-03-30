import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'nearby.dart';

class GeoFireAssistant {
  static List<NearbyMaid> nearbyMaidList = [];

  static void removemaidformlist(String key) {
    int index = nearbyMaidList.indexWhere((element) => element.key == key);
    nearbyMaidList.remove(index);
  }

  static void updatemaidinList(NearbyMaid nearbyMaid) {
    int index =
        nearbyMaidList.indexWhere((element) => element.key == nearbyMaid.key);
    nearbyMaidList[index].longitude = nearbyMaid.longitude;
    nearbyMaidList[index].latitude = nearbyMaid.latitude;
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int ran = random.nextInt(num);
    return ran.toDouble();
  }

  static String serverkey =
      "key=AAAAfD4Q12s:APA91bGZyDGmS-m1X0mhLsYlKWQvJLv_FnSGQbbC_F_19fcdmbGA9XlKND-JTC8EwFNvBIlhFHQn0qA3F69BSO8Gr8_o1_6aLNknvA0tYoTJ3K30XVxNlAhlTxlCTITZ-gCo6fmlEAI4";
  static sendNotification(String token, context, String job_request_id) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverkey
    };

    Map notificationMap = {
      "body": "You have a new Job ",
      "title": "New job alert"
    };

    Map DataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "job_request_id": job_request_id
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": DataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send' ),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }
}
