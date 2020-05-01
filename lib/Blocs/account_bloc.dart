import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Networking/account_api_provider.dart';

class AccountBloc extends ChangeNotifier {
  Account account;

  AccountBloc(){
    initBloc() async{
      AccountApiResponse res = await AccountApiProvider().getUserDetails();
      account=Account.fromAccountApiResponse(res);
      notifyListeners();
    }
    initBloc();
  }
}

class Account {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  List<NearBy> doctorsNearby;

  Account(
      {this.phoneNumber,
      this.email,
      this.lastName,
      this.firstName,
      this.doctorsNearby});

  factory Account.fromAccountApiResponse(AccountApiResponse response) {
    List nearby = response.nearby;
    print(nearby);
    List<NearBy> temp =new List();
    for(int x=0;x<nearby.length;x++){
      temp.add(NearBy.fromJson(nearby[x]));
    }
    return Account(
        firstName: response.firstName,
        lastName: response.lastName,
        phoneNumber: response.phoneNumber,
        email: response.email,
        doctorsNearby: temp);
  }
}

class NearBy{
  double latitude;
  double longitude;
  String name;
  String phoneNumber;
  String specialty;
  String email;

  NearBy({this.email,this.name,this.longitude,this.latitude,this.phoneNumber,this.specialty});

  factory NearBy.fromJson(Map<String,dynamic> json){

    return NearBy(
        latitude: double.parse(json['coordinate']['latitude']),
        longitude: double.parse(json['coordinate']['longitude']),
        name: json['name'],
        phoneNumber: json['phonenumber'],
        specialty: json['specialty'],
        email: json['email']
    );
  }
}
