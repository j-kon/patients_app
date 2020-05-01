import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_map_booking/Blocs/med_trips_bloc.dart';
import 'package:flutter_map_booking/Networking/account_api_provider.dart';
import 'package:overlay_support/overlay_support.dart';

String fcmToken;

class MessageHandler extends StatefulWidget {
  final Widget child;
  final MedTripsBloc bloc;
  MessageHandler({this.child,this.bloc});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging fm = FirebaseMessaging();
  Widget child;


  @override
  void initState() {
    super.initState();
    child = widget.child;
    fm.configure(onMessage: (Map message) async {
      if(message['data']["message"]!=null){
        showSimpleNotification(Text(message['data']["message"],style: TextStyle(color: Colors.white)),background: Colors.lightBlueAccent);
      }else{
        try{
          print("onMessage: $message");
          print(message['data']);
          widget.bloc.addTripFromJson(message['data']);
          showSimpleNotification(Text("Your request has been accepted",style: TextStyle(color: Colors.white),),background: Colors.lightBlueAccent);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Accepted request"),));
        }catch(err){
          //do nothing
        }
      }
    }, onResume: (Map message) async {
      print("onResume: $message");
    }, onLaunch: (Map message) async {
      print("onLaunch: $message");
    });

    saveDeviceToken() async {
      fcmToken = await fm.getToken();
      if (fcmToken != null) {
        print("token: $fcmToken");
        AccountApiProvider().getUserDetails();
      }
    }

    saveDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
