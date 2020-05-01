//import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//
//class PaymentApiProvider {
//  // Adding debit card to the database
//  Future<PaymentApiResponse> addCard(
//        {
//          String cardnumber,
//          String expiryyear,
//          String expirymonth,
//          String customername
//        }) async {
//    try {
//      http.Response response = await http.put(
//          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/card",
//          body: json.encode({
//            "cardnumber": cardnumber,
//            "expiryyear": expiryyear,
//            "expirymonth": expiryyear,
//            "customername": customername,
//            "key": AuthApiProvider().getAuthKey()
//          }),
//          headers: {
//            "Authorization": "KEY ${AuthApiProvider().getAuthKey()}",
//            "Content-Type": "application/json"
//          });
//      if (response.statusCode == 200) {
//        print(json.decode(response.body));
//        return PaymentApiResponse.fromJson(json.decode(response.body));
//      } else {
//        return PaymentApiResponse(success: false, message: "Error adding card");
//      }
//    } catch (err) {
//      return PaymentApiResponse(success: false, message: "No internet connection");
//    }
//  }
//
//  // Deleting debit card from the database
//  Future<PaymentApiResponse> deleteCard(
//        {
//          String cardnumber,
//          String expiryyear,
//          String expirymonth,
//          String customername
//        }) async {
//    try {
//      http.Response response = await http.delete(
//          "https://health24.herokuapp.com/d4721ee0acec3a213fdeb021231b/patients/card",
//          body: json.encode({
//            "cardnumber": cardnumber,
//            "expiryyear": expiryyear,
//            "expirymonth": expiryyear,
//            "customername": customername,
//            "key": AuthApiProvider().getAuthKey()
//          }),
//          headers: {
//            "Authorization": "KEY ${AuthApiProvider().getAuthKey()}",
//            "Content-Type": "application/json"
//          });
//      if (response.statusCode == 200) {
//        print(json.decode(response.body));
//        return PaymentApiResponse.fromJson(json.decode(response.body));
//      } else {
//        return PaymentApiResponse(success: false, message: "Error deleting card");
//      }
//    } catch (err) {
//      return PaymentApiResponse(success: false, message: "No internet connection");
//    }
//  }
//
//
//}
//
//class PaymentApiResponse {
//  String message;
//  bool success;
//
//  PaymentApiResponse({this.message, this.success});
//
//  factory PaymentApiResponse.fromJson(Map<String, dynamic> json) {
//    return PaymentApiResponse(message: json['message'], success: json['success']);
//  }
//}