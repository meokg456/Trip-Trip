import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_trip/main_screen.dart';

import 'login_screen.dart';
import 'manager/my_api_client.dart';

class Splash extends StatelessWidget {
  Future<void> checkRoute(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    String accessToken = preferences.getString('token');
    print(accessToken);
    if (accessToken != null) {
      MyAPIClient.accessToken = accessToken;
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    } else {
      print('Login');
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkRoute(context);
    return Scaffold(
        backgroundColor: Color(0xffffdd59),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 150)),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Image.asset('Icons/touch.png',
                              height: 70, width: 70, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          'Future Touch Team',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff0fbcf9)),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      'Travel assistant\n for every one',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
