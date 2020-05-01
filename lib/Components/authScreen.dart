import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Blocs/auth_bloc.dart';
import 'package:flutter_map_booking/Blocs/med_trips_bloc.dart';
import 'package:flutter_map_booking/message_handler.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final Widget logInScreen;
  final Widget onLoggedInScreen;

  AuthScreen({this.onLoggedInScreen, this.logInScreen});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(
      builder: (context, authBloc, child) {
        if (authBloc.authState != null) {
          if (authBloc.authState == AuthState.signedOut) {
            return logInScreen;
          }

          if (authBloc.authState == AuthState.signedIn) {
            return Consumer<MedTripsBloc>(
              builder: (context,bloc,child){
                return MessageHandler(
                  child: onLoggedInScreen,
                  bloc: bloc,
                );
              },
            );
          }
        }
        return Scaffold(
          body: Container(),
        );
      },
    );
  }
}
