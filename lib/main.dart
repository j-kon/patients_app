import 'package:flutter_map_booking/Blocs/auth_bloc.dart';
import 'package:flutter_map_booking/Blocs/med_trips_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'Blocs/place_bloc.dart';
import 'app_router.dart';
import 'package:flutter/material.dart';
import 'Screen/SplashScreen/splash_screen.dart';
import 'theme/style.dart';

void main() => runApp(
  OverlaySupport(
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AuthBloc()),
        ChangeNotifierProvider(create: (context)=>MedTripsBloc()),
        ChangeNotifierProvider(create: (context)=>PlaceBloc())
      ],
      child: MyApp(),
    ),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaceBloc>(
      create: (context) => PlaceBloc(),
      child: MaterialApp(
        title: 'Taxi App',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoute.generateRoute,
        home: SplashScreen(),
      )
    );
  }
}
