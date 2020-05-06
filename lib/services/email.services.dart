import 'dart:convert';
import 'package:piggybanx/Enums/userType.dart';
import 'package:http/http.dart' as http;

class EmailService {
  //Debug
  // static String url = "http://localhost:8080/";

  //Release
  static String url = "https://piggybanx.herokuapp.com/";

  static sendInviteEmail(
      String inviter, UserType inviterType, String email) async {
    Map<String, Object> data = {
      'inviter': inviter,
      'userType': inviterType.index,
      'email': email
    };
    var jsonString = json.encode(data);

    var response = await http.post(url + "sendInvite",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonString);
    print(response);
  }
}
