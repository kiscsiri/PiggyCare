import 'dart:convert';

import 'package:http/http.dart' as http;

class PaysafeAPI {
  static init() async {

    Map<String, Object> mappedData = {
      "type": "PAYSAFECARD",
      "amount": "0.1",
      "currency": "EUR",
      "notification_url": "",
    };
    
    var jsonString = json.encode(mappedData);

    await http.post("https://private-anon-26455cec77-paysafecardapien.apiary-proxy.com/v1/payments", body:jsonString );
  }
}