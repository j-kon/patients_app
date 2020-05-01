import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
class LocationApiProvider{
  Future<Position> getCurrentLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator();
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on PlatformException{
      position = null;
    }
    return position;
  }
}