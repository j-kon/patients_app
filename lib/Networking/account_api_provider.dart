import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
import 'package:flutter_map_booking/Networking/location_api_provider.dart';
import 'package:flutter_map_booking/message_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AccountApiProvider {
  Future<AccountApiResponse> getUserDetails() async {
    if(prefs==null){
      prefs=await SharedPreferences.getInstance();
    }
    Position position = await  LocationApiProvider().getCurrentLocation();
    print("longitude: ${position.longitude}..................");
    print("lattitude: ${position.latitude}..................");
    http.Response response = await http.post(
        "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients",
        body: json.encode({
          "coordinate": {"latitude": position.latitude, "longitude": position.longitude},
          "key":
              "${AuthApiProvider().getAuthKey()}",
          "notification_token": fcmToken!=null?fcmToken:"fTy2mo2yhOo:APA91bHeSvWEDYVFF28qZf7qfFJ8RQ3dY5wtnl0Ccl7vlOpPYZa9XESF4iZlF5GJRtvQLaqTMNsnzdA24Y-sqxLOFJbj64On7R-3L80ijhm92Rqhyn-84m52BFkSQu8mgEuQafS6pO9N"
        }),
        headers: {
          "Authorization":
              "KEY ${AuthApiProvider().getAuthKey()}",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return AccountApiResponse.fromJson(json.decode(response.body));
    } else {
      print(response.body);
      return AccountApiResponse(success: false);
    }
  }
}

class AccountApiResponse {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  List nearby;
  bool success;

  AccountApiResponse(
      {this.success,
      this.lastName,
      this.firstName,
      this.email,
      this.phoneNumber,
      this.nearby});

  factory AccountApiResponse.fromJson(Map<String, dynamic> json) {
    return AccountApiResponse(
        firstName: json['patient']['firstname'],
        lastName: json['patient']['lastname'],
        email: json['patient']['email'],
        phoneNumber: json['patient']['phonenumber'],
        success: json['success'],
        nearby: json['patient']['nearby']);
  }
}
