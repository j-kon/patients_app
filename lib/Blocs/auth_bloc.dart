import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends ChangeNotifier{
  final authApiProvider = AuthApiProvider();
  AuthState authState;

  AuthBloc(){
    initAuthStatus() async{
      if(prefs==null){
        prefs=await SharedPreferences.getInstance();
      }
      String key = authApiProvider.getAuthKey();
      if(key==null){
        authState=AuthState.signedOut;
//        authState=AuthState.signedIn;
        notifyListeners();
      }else{
        authState=AuthState.signedIn;
        notifyListeners();
      }
    }
    initAuthStatus();
  }


  Future<AuthApiResponse> signUp(
      {String firstName,
        String lastName,
        String email,
        String phoneNumber,
        String password}) =>
      authApiProvider.signUp(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          password: password);

  Future<AuthApiResponse> signIn(String phone) => authApiProvider.signIn(phone);

  Future<AuthApiResponse> signInVerification(
      {String phoneNumber, String token}) async {
    AuthApiResponse response = await authApiProvider.signInVerification(
        phoneNumber: phoneNumber, token: token);
    if (response.success) {
      authState=AuthState.signedIn;
      notifyListeners();
    }
    return response;
  }


  Future<AuthApiResponse> registrationVerification(
      {String phoneNumber, String token}) async {
    AuthApiResponse response = await authApiProvider.registrationVerification(
        phoneNumber: phoneNumber, token: token);
    if (response.success) {
      authState=AuthState.signedIn;
      notifyListeners();
    }
    return response;
  }

  void signOut() {
    authState=AuthState.signedOut;
  }
}



enum AuthState {
  signedIn,
  signedOut,
}