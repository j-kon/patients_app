import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

class AuthApiProvider {
  AuthApiProvider() {
    initSharedPrefs() async {
      if(prefs==null){
        prefs = await SharedPreferences.getInstance();
      }
    }

    initSharedPrefs();
  }

  Future<AuthApiResponse> signUp(
      {String firstName,
        String lastName,
        String email,
        String phoneNumber,
        String password}) async {
    try {
      http.Response response = await http.post(
          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/register",
          body: json.encode({
            "firstname": firstName,
            "lastname": lastName,
            "email": email,
            "phonenumber": phoneNumber,
            "password": password
          }),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return AuthApiResponse.fromJson(json.decode(response.body));
      } else {
        return AuthApiResponse(
            success: false, message: "Error registering you");
      }
    } catch (err) {
      return AuthApiResponse(success: false, message: "No internet connection");
    }
  }

  Future<AuthApiResponse> signIn(String phoneNumber) async {
    try {
      http.Response response = await http.post(
          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/authenticate",
          body: json.encode({"phonenumber": phoneNumber}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return AuthApiResponse.fromJson(json.decode(response.body));
      } else {
        return AuthApiResponse(success: false, message: "Error signing in");
      }
    } catch (err) {
      return AuthApiResponse(success: false, message: "No internet connection");
    }
  }

  Future<AuthApiResponse> signInVerification(
      {String phoneNumber, String token}) async {
    try {
      http.Response response = await http.post(
          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/verify",
          body: json.encode({"phonenumber": phoneNumber, "token": token, "register": false}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['success']==true){
          saveAuthKey(json.decode(response.body)['key']);
          goOnline();
        }
        return AuthApiResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        return AuthApiResponse(success: false, message: "An error ocuured");
      }
    } catch (err) {
      return AuthApiResponse(success: false, message: "No internet connection");
    }
  }

  Future<AuthApiResponse> registrationVerification(
      {String phoneNumber, String token}) async {
    try{
      http.Response response = await http.post(
          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/verify",
          body: json.encode({"phonenumber": phoneNumber, "token": token, "register": true}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['success']==true){
          saveAuthKey(json.decode(response.body)['key']);
          goOnline();
        }
        return AuthApiResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        return AuthApiResponse(success: false, message: "Something went wrong");
      }
    }catch(err){
      return AuthApiResponse(success: false, message: "No internet connection");
    }
  }

  Future<AuthApiResponse> goOnline() async {
    try{
      http.Response response = await http.post(
          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/online",
          body: json.encode({
            "coordinate": {"latitude": -23.6, "longitude": 8.5},
            "key":
            "${getAuthKey()}"
          }),
          headers: {
            "Authorization":
            "KEY ${getAuthKey()}",
            "Content-Type": "application/json"
          });
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return AuthApiResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        return AuthApiResponse(success: false, message: "Something went wrong");
      }
    }catch(err){
      return AuthApiResponse(success: false, message: "No internet connection");
    }
  }

  void saveAuthKey(String key) {
    prefs.setString("authKey", key);
  }

  String getAuthKey() {
    return prefs.getString("authKey");
  }
}

class AuthApiResponse {
  String message;
  bool success;

  AuthApiResponse({this.message, this.success});

  factory AuthApiResponse.fromJson(Map<String, dynamic> json) {
    if( json['message']==null){
      return AuthApiResponse(message: "something went wrong", success: json['success']);
    }
    return AuthApiResponse(message: json['message'], success: json['success']);
  }
}
