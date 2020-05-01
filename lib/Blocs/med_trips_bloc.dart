import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Networking/location_api_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MedTripsBloc extends ChangeNotifier{
  List<MedTrip> medTrips = new List();
  bool tripInProgress = false;
  List<Polyline> polyLines = new List();
  MedTrip currentTrip;


  void addTripFromJson(Map json){
    print("ADDING TRIP...........................");
    try{
      MedTrip trip =MedTrip.fromJson(json);
      medTrips.add(trip);
      tripInProgress=true;
      currentTrip=trip;
      addPolyline(LatLng(double.parse(trip.latitude),double.parse(trip.longitude)));
      notifyListeners();
    }catch(err){
      print(err);
    }
  }

  void endTrip(){
    tripInProgress=false;
    polyLines = new List();
    notifyListeners();
  }

  void addTrip(MedTrip trip){
    print("ADDING TRIP...........................");
    try{
      medTrips.add(trip);
      tripInProgress=true;
      currentTrip=trip;
      addPolyline(LatLng(double.parse(trip.latitude),double.parse(trip.longitude)));
      notifyListeners();
    }catch(err){
      print(err);
    }
  }

  void addPolyline(LatLng destination) async {
    Position position = await LocationApiProvider().getCurrentLocation();
    List<LatLng> coordinates = await getPlyLines(LatLng(position.latitude,position.longitude), destination);
    try{
      Polyline line = Polyline(polylineId: PolylineId("hhh"), points: coordinates);
      polyLines.add(line);
    }catch(err){
      print(err);
    }
    notifyListeners();
  }
}

class MedTrip{
  String latitude;
  String longitude;
  String doctorName;
  String doctorPhoneNumber;
  String doctorSpecialty;
  String doctorEmail;
  String timeToArrive;
  String patientId;

  MedTrip({this.longitude,this.latitude,this.doctorEmail,this.doctorName,this.doctorPhoneNumber,this.doctorSpecialty,this.timeToArrive,this.patientId});
  factory MedTrip.fromJson(Map jsonn){
    Map doc = json.decode(jsonn["doctor"]);
    return MedTrip(
      longitude: doc['coordinate']['longitude'],
      latitude:  doc['coordinate']['latitude'],
      doctorName: doc['name'],
      doctorPhoneNumber: doc['phonenumber'],
      doctorSpecialty: doc['specialty'],
      doctorEmail: doc['email'],
      timeToArrive: jsonn['timeToArrive'],
      patientId: jsonn['patient_id']
    );
  }

}