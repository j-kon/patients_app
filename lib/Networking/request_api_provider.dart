import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import 'auth_api_provider.dart';

class RequestApiProvider{
  SocketIO socketIO;

  RequestApiProvider(){
    socketIO = SocketIOManager().createSocketIO(
        "https://health24.herokuapp.com", "/patients",query: "x-auth-header=${AuthApiProvider().getAuthKey()}",
        socketStatusCallback: (data) {
          print("patient: "+data);
        });
    socketIO.subscribe("error", (data) {
      print("patient: "+data);
    });
    socketIO.init();
    socketIO.connect();
  }

  void makeRequest(){
    socketIO.sendMessage("request",json.encode({"payload":"..."}),(data){
      print(data);
    });
  }

  void cancelRequest({String patientId}){
    socketIO.sendMessage("cancel",json.encode({"patient_id":patientId}),(data){
    });
  }
}