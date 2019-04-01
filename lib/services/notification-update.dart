import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

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

    var result = await http
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

  static updateSettings() async {
    Map<String, Object> mappedData = {
      "token": "asd",
      "uid": "asds",
      "platform": "android"
    };

    var jsonString = json.encode(mappedData);

    var result = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
  }
}
