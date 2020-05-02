import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map_booking/Blocs/account_bloc.dart';
import 'package:flutter_map_booking/Blocs/med_trips_bloc.dart';
import 'package:flutter_map_booking/Blocs/request_state_bloc.dart';
import 'package:flutter_map_booking/Networking/account_api_provider.dart';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Networking/request_api_provider.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'package:flutter_map_booking/Screen/Menu/menu_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen2 extends StatefulWidget {
  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  _HomeScreen2State();
  final String screenName = "HOME2";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<LatLng> points = <LatLng>[];
  GoogleMapController _mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  MarkerId selectedMarker;
  BitmapDescriptor _markerIcon;
  CircleId selectedCircle;

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  PolylineId selectedPolyline;
  bool checkPlatform = Platform.isIOS;
  Position _position = Position(latitude: 6.5,longitude: 9.6);
  String placemark = '';
  double distance = 0;
  LatLng currentLocation = LatLng(39.170655, -95.449974);
  Position currentPosition;
  List<Map<String, dynamic>> listDistance = [{"id": 1, "title": "5 km"},{"id": 2, "title": "10 km"},{"id":3,"title": "15 km"}];
  String selectedDistance = "1";
  double _radius = 5000;
  Position _lastKnownPosition;
  PermissionStatus permission;
  final Geolocator _locationService = Geolocator();
  List<Polyline> polyLines = new List();
  Timer t;

  List<dynamic> dataMarKer = [];
  bool firstBuild = true;
  void moveCameraToMyLocation(){
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude,currentLocation?.longitude),
          zoom: 13.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    t=Timer.periodic(Duration(seconds: 30), (timer){
      _getCurrentLocation();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
    _mapController?.animateCamera(
        CameraUpdate?.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude,currentLocation.longitude),
              zoom: 13,
            )
        )
    );
    _addCircle();

    for(int i=0;i<dataMarKer.length;i++){
      distance = calculateDistance(currentLocation.latitude,currentLocation.longitude,dataMarKer[i]['lat'],dataMarKer[i]['lng']);
      if(distance*1000 < _radius){
        _addMarker(dataMarKer[i]['id'], dataMarKer[i]['lat'], dataMarKer[i]['lng']);
      }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    Position position= await Provider.of<PlaceBloc>(context,listen: false).getCurrentLocation2();
    if (!mounted) {
      return;
    }
    setState(() {
      _position = position;
      currentLocation=LatLng(_position.latitude,_position.longitude);
    });
    _addCircle();
    setMarkers() async{
      AccountApiResponse res = await AccountApiProvider().getUserDetails();
      Account account = Account.fromAccountApiResponse(res);
      setState(() {
        dataMarKer=new List();
        for(int x=0;x<account.doctorsNearby.length;x++){
          dataMarKer.add({
            "id": "${x+1}",
            "lat": account.doctorsNearby[x].latitude,
            "lng": account.doctorsNearby[x].longitude
          });
        }
      });
    }
    setMarkers().then((val){
      for(int i=0;i<dataMarKer.length;i++){
        distance = calculateDistance(currentLocation.latitude,currentLocation.longitude,dataMarKer[i]['lat'],dataMarKer[i]['lng']);
        if(distance*1000 < _radius){
          _addMarker(dataMarKer[i]['id'], dataMarKer[i]['lat'], dataMarKer[i]['lng']);
        }
      }
    });
    if(firstBuild==true){
      moveCameraToMyLocation();
    }
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(_position.latitude, _position.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        placemark = pos.thoroughfare + ', ' + pos.locality;
        firstBuild=false;
      });
    }
  }


  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, checkPlatform ? 'assets/image/marker/car_top_48.png' : "assets/image/marker/car_top_96.png")
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  void _addMarker(String markerIdVal, double lat, double lng) async {
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: checkPlatform ? BitmapDescriptor.fromAsset("assets/image/marker/car_top_48.png") : BitmapDescriptor.fromAsset("assets/image/marker/car_top_96.png"),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addCircle() {
    final int circleCount = circles.length;
    if (circleCount == 12) {
      return;
    }
    final String circleIdVal = 'circle_id';
    final CircleId circleId = CircleId(circleIdVal);

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Color.fromRGBO(135, 206, 250, 0.9),
      fillColor: Color.fromRGBO(135, 206, 250, 0.3),
      strokeWidth: 4,
      center: LatLng(currentLocation.latitude,currentLocation.longitude),
      radius: _radius,
    );
    setState(() {
      circles[circleId] = circle;
    });
  }

  /// Widget change the radius Circle.
  Widget getListOptionDistance() {
    final List<Widget> choiceChips = listDistance.map<Widget>((value) {
      return new Padding(
          padding: const EdgeInsets.all(3.0),
          child: ChoiceChip(
              key: ValueKey<String>(value['id'].toString()),
              labelStyle: textGrey,
              backgroundColor: greyColor2,
              selectedColor: primaryColor,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              selected: selectedDistance == value['id'].toString(),
              label: Text((value['title'])),
              onSelected: (bool check) {
                setState(() {
                  selectedDistance = check ? value["id"].toString() : '';
                  changeCircle(selectedDistance);
                });
              })
      );
    }).toList();
    return new Wrap(
        children: choiceChips
    );
  }

  ///Filter and display markers in that area
  ///My data is demo. You can get data from your api and use my function
  ///to filter and display markers around the current location.
  changeCircle(String selectedCircle){
    if(selectedCircle == "1"){
      setState(() {
        _radius = 5000;
        _moveCamera(11.5);
      });
    }
    if(selectedCircle == "2"){
      setState(() {
        _radius = 10000;
        _moveCamera(11.2);
      });
    }
    if(selectedCircle == "3"){
      setState(() {
        _radius = 15000;
        _moveCamera(10.5);
      });
    }
    _addCircle();
    for(int i=0;i<dataMarKer.length;i++){
      distance = calculateDistance(currentLocation.latitude,currentLocation.longitude,dataMarKer[i]['lat'],dataMarKer[i]['lng']);
      if(distance*1000 < _radius){
        _addMarker(dataMarKer[i]['id'], dataMarKer[i]['lat'], dataMarKer[i]['lng']);
      } else {
        print(dataMarKer[i]['id']);
        _remove(dataMarKer[i]['id']);
      }
    }
  }

  void _remove(String idMarker) {
    final MarkerId markerId = MarkerId(idMarker);
    setState(() {
      markers.remove(markerId);
    });
  }

  _moveCamera(double zoom){
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude,currentLocation.longitude),
            zoom: zoom,
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return new Scaffold(
      key: _scaffoldKey,
      drawer: new MenuScreens(activeScreenName: screenName),
      body: new Container(
        color: Colors.white,
        child: SingleChildScrollView(
            child: new SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Consumer<MedTripsBloc>(
                builder: (context,bloc,child){
                  try{
                    if(bloc.tripInProgress==true){
                      t.cancel();
                    }else{
                      t =Timer.periodic(Duration(seconds: 30), (timer){
                        _getCurrentLocation();
                      });
                    }
                  }catch(err){
                    print(err);
                  }
                  return Stack(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: GoogleMap(
                                circles: bloc.tripInProgress==true?null:Set<Circle>.of(circles.values),
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(currentLocation.latitude,currentLocation.longitude),
                                  zoom: 13,
                                ),
                                markers: bloc.tripInProgress?[
                                  Marker(
                                      markerId: MarkerId("patient"),
                                      position: LatLng(currentLocation.latitude,currentLocation.longitude)
                                  ),
                                  Marker(
                                    markerId: MarkerId("dcotor"),
                                    position: LatLng(double.parse(bloc.currentTrip.latitude),double.parse(bloc.currentTrip.longitude)),
                                    icon: checkPlatform ? BitmapDescriptor.fromAsset("assets/image/marker/car_top_48.png") : BitmapDescriptor.fromAsset("assets/image/marker/car_top_96.png"),
                                  )
                                ].toSet():Set<Marker>.of(markers.values),
                                polylines:bloc.tripInProgress==true? bloc.polyLines.toSet().length == 0 ? null : bloc.polyLines.toSet():null,
                              )
                          ),

                        ],
                      ),
                      bloc.tripInProgress==false?Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              centerTitle: true,
                              leading: FlatButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                  child: Icon(Icons.menu,color: blackColor,)
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              child: getListOptionDistance(),
                            )
                          ],
                        ),
                      ):Container(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: bloc.tripInProgress==true?MedTripCard(
                              trip:bloc.currentTrip,
                            bloc: bloc,
                          ):Consumer<RequestStateBloc>(
                            builder: (context,bloc,child){
                              String requestId = "homePageMakeRequestButton";
                              return RaisedButton(
                                onPressed: (){
                                  if(bloc.checkStatus(requestId: requestId)!=RequestStatus.SUCCESSFUL){
                                    bloc.makeRequest(requestId: requestId);
                                  }
                                },
                                color: bloc.checkStatus(requestId: requestId)==RequestStatus.FAILED?Colors.red:Colors.blueAccent,
                                child: Text(
                                  bloc.checkStatus(requestId: requestId)==RequestStatus.SUCCESSFUL?"WAITING FOR DOCTORS RESPONSE":bloc.checkStatus(requestId: requestId)==RequestStatus.PENDING?"MAKE REUEST":"EEROR MAKING REQUEST. TRY AGAIN",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
        ),
      ),
    );
  }
}

class MedTripCard extends StatelessWidget {
  final MedTrip trip;
  final MedTripsBloc bloc;
  MedTripCard({this.trip,this.bloc}):super(key: new GlobalKey());
  @override
  Widget build(BuildContext context){
    final screenSize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.all(1.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: CachedNetworkImage(
                        imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                        fit: BoxFit.cover,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(trip.doctorName,style: textBoldBlack,),
                        Text("08 Jan 2019 at 12:00 PM", style: textGrey,),
//                        Container(
//                          child: Row(
//                            children: <Widget>[
//                              Container(
//                                height: 25.0,
//                                padding: EdgeInsets.all(5.0),
//                                alignment: Alignment.center,
//                                decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(10.0),
//                                    color: primaryColor
//                                ),
//                                child: Text('ApplePay',style: textBoldWhite,),
//                              ),
//                              SizedBox(width: 10),
//                              Container(
//                                height: 25.0,
//                                padding: EdgeInsets.all(5.0),
//                                alignment: Alignment.center,
//                                decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(10.0),
//                                    color: primaryColor
//                                ),
//                                child: Text('Discount',style: textBoldWhite,),
//                              ),
//                            ],
//                          ),
//                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${trip.timeToArrive} away",style: textBoldBlack,),
//                        Text("2.2 Km",style: textGrey,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(trip.doctorSpecialty,style: textGreyBold,),
                          Text(trip.doctorPhoneNumber,style: textStyle,),

                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(trip.doctorEmail,style: textGreyBold,),
//                          Text("2536 Flying Taxicabs",style: textStyle,),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ButtonTheme(
                minWidth: screenSize.width ,
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                  elevation: 0.0,
                  color: Colors.redAccent,
                  child: Text('Cancel',style: headingWhite),
                  onPressed: () async{
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Are you sure you want to cancel your Med trip?")
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("YES",style: TextStyle(color: Colors.lightBlueAccent),),
                              onPressed: () async{
                                Navigator.pop(context);
                                RequestApiProvider().cancelRequest(patientId: trip.patientId);
                                bloc.endTrip();
                              },
                            ),
                            FlatButton(
                              child: Text("NO",style: TextStyle(color: Colors.lightBlueAccent),),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )  ;
                      }
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
