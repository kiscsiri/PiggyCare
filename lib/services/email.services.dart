import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  //Debug
  // static String url = "http://localhost:8080/";

  //Release
  static String url = "https://piggybanx.herokuapp.com/";

  static sendInviteEmail(String inviter, String email) async {
    Map<String, Object> data = {'inviter': inviter, 'email': email};
    var jsonString = json.encode(data);

    await http
        .post(url + "sendInvite",
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
