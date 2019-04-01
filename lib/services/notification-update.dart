import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piggybanx/Enums/period.dart';

class NotificationUpdate {
  //Debug
  // static String url = "http://localhost:8080";

  //Release
  static String url = "https://piggybanx.herokuapp.com/";

  static register(String token, String uid, String platform) async {
    Map<String, Object> mappedData = {
      "device_id": token,
      "userId": uid,
      "platform": platform
    };

    var jsonString = json.encode(mappedData);

    await http
        .post(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((value) {
      print(value.statusCode);
    });
  }

  static feedPiggy(String uid) async {
    Map<String, Object> mappedData = {
      "userId": uid,
    };

    var jsonString = json.encode(mappedData);

    await http.put(url + "feed",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonString).then((val) {
          print(val);
        });
  }

  static updateSettings(Period period, String uid) async {
    Map<String, Object> mappedData = {
      'userId': uid,
      "feedPeriod": period.index,
    };

    var jsonString = json.encode(mappedData);

    await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonString).then((val) {
          print(val);
        });
  }

    static updateToken(String token, String uid) async {
    Map<String, Object> mappedData = {
      'userId': uid,
      "device_id": token,
    };

    var jsonString = json.encode(mappedData);

    await http.put(url + "updateToken",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonString).then((val) {
          print(val);
        });
  }
}
