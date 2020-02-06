import 'package:flutter/material.dart';
import 'package:trip_trip/splash_screen.dart';

Future<void> main() async {
  runApp(TripTrip());
}

class TripTrip extends StatelessWidget {
  const TripTrip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Trip',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.orange[300],
          accentColor: Colors.orange[300]),
      home: Splash(),
    );
  }
}
