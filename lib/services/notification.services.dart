import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piggybanx/enums/period.dart';

class NotificationServices {
  //Debug
  // static String url = "http://localhost:8080/";

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

    await http
        .put(url + "feed",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static updateSettings(Period period, String uid) async {
    Map<String, Object> mappedData = {
      'userId': uid,
      "feedPeriod": period.index,
    };

    var jsonString = json.encode(mappedData);

    await http
        .put(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static updateToken(String token, String uid, String platform) async {
    Map<String, Object> mappedData = {
      "userId": uid,
      "device_id": token,
      "platform": platform
    };

    var jsonString = json.encode(mappedData);

    await http
        .put(url + "updateToken",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static newFriendRequest(String uid, String userName) async {
    Map<String, Object> mappedData = {"targetId": uid, 'userName': userName};
    var jsonString = json.encode(mappedData);

    await http
        .put(url + "sendFriendRequest",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static sendNotificationFinishedTask(String parentId, String name,
      String taskName, int taskId, String userId) async {
    Map<String, Object> mappedData = {
      "targetId": parentId,
      'userName': name,
      'taskName': taskName,
      'taskId': taskId,
      'senderId': userId
    };
    var jsonString = json.encode(mappedData);

    await http
        .put(url + "finishedTask",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static sendNotificationNewTask(String parentId, String userName) async {
    Map<String, Object> data = {'targetId': parentId, 'userName': userName};

    var jsonString = json.encode(data);

    await http
        .put(url + "newTask",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static sendNotificationValidatedTask(String childId, int taskId) async {
    Map<String, Object> data = {'targetId': childId, 'taskId': taskId};
    var jsonString = json.encode(data);

    await http
        .put(url + "validatedTask",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static sendNotificationNewPiggy(String childId) async {
    Map<String, Object> data = {
      'childId': childId,
    };
    var jsonString = json.encode(data);

    await http
        .put(url + "newPiggy",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static sendNotificationDouble(
      String targetId, String userName, String fromId) async {
    Map<String, Object> data = {
      'targetId': targetId,
      'fromId': fromId,
      'userName': userName
    };
    var jsonString = json.encode(data);

    await http
        .put(url + "double",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }

  static Future<void> sendNotificationRefusedTask(childId, taskId) async {
    Map<String, Object> data = {'targetId': childId, 'taskId': taskId};
    var jsonString = json.encode(data);

    await http
        .put(url + "refusedTask",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonString)
        .then((val) {
      print(val);
    });
  }
}
