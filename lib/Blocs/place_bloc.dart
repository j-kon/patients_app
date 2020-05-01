import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_booking/Model/place_model.dart';
import 'package:flutter_map_booking/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:polyline/polyline.dart' as ply;

class PlaceBloc with ChangeNotifier {
  StreamController<Place> locationController = StreamController<Place>.broadcast();
  Place locationSelect;
  Place formLocation;
  List<Place> listPlace;


  //current positon
  Position position = Position(latitude: 6.4,longitude: 9.6);

  Stream get placeStream => locationController.stream;

  Future<List<Place>> search(String query) async {
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.apiKey}&language=${Config.language}&region=${Config.region}&query="+Uri.encodeQueryComponent(query);//Uri.encodeQueryComponent(query)
    print(url);
    Response response = await Dio().get(url);
    print(Place.parseLocationList(response.data));
    listPlace = Place.parseLocationList(response.data);
    notifyListeners();
    return listPlace;
  }

  void locationSelected(Place location) {
    locationController.sink.add(location);
  }

  Future<void> selectLocation(Place location) async {
    notifyListeners();
    locationSelect = location;
    return locationSelect;
  }

  Future<void> getCurrentLocation(Place location) async {
    notifyListeners();
    formLocation = location;
    return formLocation;
  }

  Future<Position> getCurrentLocation2() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator();
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on PlatformException {
      position = null;
    }
    this.position=position;
    notifyListeners();
    return position;
  }


  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}

Future<List<LatLng>> getPlyLines(LatLng origin, LatLng destination) async {
  print("GETTING POLYLINES..........................");
  ply.Polyline polyline;
  final response = await http.get(
      "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=AIzaSyAsqbQFk0dxZ841a98cYndeAZo_O8V-nQA");
  if (response.statusCode == 200) {
    print(
        json.decode(response.body)['routes'][0]['overview_polyline']['points']);
    polyline = ply.Polyline.Decode(
        precision: 5,
        encodedString: json.decode(response.body)['routes'][0]
        ['overview_polyline']['points']);
    return convertDecodedCoordsToLatLng(polyline);
  } else {
    print(response.body);
    return null;
  }
}

List<LatLng> convertDecodedCoordsToLatLng(ply.Polyline polyline) {
  var coords = polyline.decodedCoords;
  List<LatLng> coordinates = new List();
  coords.forEach((coord) {
    coordinates.add(LatLng(coord[0], coord[1]));
  });
  return coordinates;
}