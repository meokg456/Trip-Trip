import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_trip/manager/my_api_client.dart';
import 'package:trip_trip/manager/validator.dart';
import 'manager/constant.dart';
import 'dart:convert' as convert;
import 'package:trip_trip/widgets.dart';
import 'package:trip_trip/register_screen.dart';
import 'travel_assistant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  FocusNode passwordFocusNode;

  void registerPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  Future<void> loginPressed() async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }
    var response = await MyAPIClient.client.post(Constant.login_url, body: {
      'emailPhone': _usernameController.text,
      'password': _passwordController.text
    });
    print('Response status: ${response.statusCode}');
    var jsonResponse = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Success');
      final preferences = await SharedPreferences.getInstance();
      print(jsonResponse['token']);
      preferences.setString('token', jsonResponse['token']);
      MyAPIClient.accessToken = jsonResponse['token'];
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      var msg = jsonResponse["message"];
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(msg),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 70,
                left: 70,
                right: 70,
                bottom: 30,
              ),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(Constant.login_button,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AppFont',
                            color: Colors.white)),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    textFormField(
                        Constant.username_edittext_hint,
                        _usernameController,
                        (String value) => FocusScope.of(context)
                            .requestFocus(passwordFocusNode),
                        Validator.validateUsername,
                        action: TextInputAction.next),
                    textFormField(
                        Constant.password_edittext_hint,
                        _passwordController,
                        (String value) => loginPressed(),
                        Validator.validatePassword,
                        isObserved: true,
                        focusNode: passwordFocusNode,
                        action: TextInputAction.done),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    gradientButton(Constant.login_button, loginPressed),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    gradientButton(Constant.register_button, registerPressed),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Login with',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Images/login_background.png'),
              fit: BoxFit.cover)),
    );
  }
}
