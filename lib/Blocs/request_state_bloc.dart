import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';

class RequestStateBloc extends ChangeNotifier{
  Request latestRequest;
  String latestRequestId;
  Map<String,RequestStatus> requestStatus = new Map<String,RequestStatus>();
  SocketIO socketIO;

  RequestStateBloc(){
    socketIO = SocketIOManager().createSocketIO(
        "https://health24.herokuapp.com", "/patients",query: "x-auth-header=${AuthApiProvider().getAuthKey()}",
        socketStatusCallback: (data) {
          print("STATUS UPDATE: "+data);
        });

    socketIO.subscribe("connect_error", (data){
      print("CONNECT ERROR");
      if(latestRequestId!=null){
        if(requestStatus.containsKey(latestRequestId)){
          requestStatus[latestRequestId]= RequestStatus.FAILED;
          notifyListeners();
        }
      }
    });

    socketIO.subscribe("error", (data) {
      //check if id is already flagged
      if(requestStatus.containsKey(latestRequestId)){
        requestStatus[latestRequestId]= RequestStatus.FAILED;
      }else{
        requestStatus.putIfAbsent(latestRequestId, ()=>RequestStatus.FAILED);
      }
      notifyListeners();
      print("patient: "+data);
    });

    socketIO.init();
    socketIO.connect().catchError((err){
      print("ERRORRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
      print(err);
    });
  }

  void makeRequest({String requestId}){
    socketIO.connect();
    latestRequest=Request.REQUEST_MED_TRIP;
    latestRequestId=requestId;
    requestStatus.putIfAbsent(requestId,()=>RequestStatus.SUCCESSFUL);
    if(requestStatus.containsKey(requestId)){
      requestStatus[requestId] = RequestStatus.SUCCESSFUL;
    }
    try{
      socketIO.sendMessage("request",json.encode({"payload":"..."}),(data){
        print("CALLBACK:  "+data);
      });
    }catch(err){
      requestStatus.putIfAbsent(requestId,()=>RequestStatus.FAILED);
    }
    notifyListeners();
  }

  void cancelRequest({String patientId,requestId}){
    latestRequest=Request.CANCEL_MED_TRIP;
    latestRequestId=requestId;
    requestStatus.putIfAbsent(requestId,()=>RequestStatus.SUCCESSFUL);
    notifyListeners();
    socketIO.sendMessage("cancel",json.encode({"patient_id":patientId}),(data){
    });
  }

  RequestStatus checkStatus({String requestId}){
    if(requestStatus.containsKey(requestId)){
      return requestStatus[requestId];
    }
    return RequestStatus.PENDING;
  }
}


enum Request {
  CANCEL_MED_TRIP,
  REQUEST_MED_TRIP,
}

enum RequestStatus{
  SUCCESSFUL,
  FAILED,
  PENDING
}
