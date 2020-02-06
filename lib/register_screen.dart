import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_trip/manager/my_api_client.dart';
import 'package:trip_trip/manager/validator.dart';
import 'package:trip_trip/widgets.dart';
import 'dart:convert' as convert;
import 'manager/constant.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _dob = Constant.dob_edittext_action;

  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController _fullNameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  int _gender = 1;

  final _emailFocusNode = FocusNode();

  final _phoneFocusNode = FocusNode();

  final _addressFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  final _confirmPasswordFocusNode = FocusNode();

  String isValidConfirmPassword(String value) {
    if (value.isEmpty) return Constant.password_edittext_error;
    if (_passwordController.text != value) {
      return Constant.confirm_password_edittext_error;
    }
    return null;
  }

  Future<void> registerPressed() async {
    if (!_registerFormKey.currentState.validate()) return;
    var requestBody = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'fullname': _fullNameController.text,
      'gender': _gender,
      'address': _addressController.text,
      'dob': _dob,
    };
    print(requestBody);
    String jsonRequest = convert.jsonEncode(requestBody);
    var jsonResponse = await MyAPIClient.client.post(Constant.register_url,
        headers: {'content-type': 'application/json'}, body: jsonRequest);
    if (jsonResponse.statusCode == 200) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      var response = convert.jsonDecode(jsonResponse.body);
      var messages = response['message'];
      var errCount = response['error'];
      StringBuffer notify = StringBuffer();
      for (int i = 0; i < errCount; i++) {
        if (i == errCount - 1) {
          notify.write("${messages[i]['msg']}");
          break;
        }
        notify.write("${messages[i]['msg']}\n");
      }
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(notify.toString()),
              titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      print(messages[0]['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Images/login_background.png'),
                fit: BoxFit.cover)),
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.transparent),
            ),
            Container(
              margin: EdgeInsets.all(60),
              child: Text(Constant.register_button,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AppFont',
                      color: Colors.white)),
            ),
            Form(
              key: _registerFormKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: <Widget>[
                    textFormField(
                        Constant.fullname_edittext_hint,
                        _fullNameController,
                        (String value) => FocusScope.of(context)
                            .requestFocus(_emailFocusNode),
                        (String value) {},
                        action: TextInputAction.next),
                    textFormField(
                      Constant.email_edittext_hint,
                      _emailController,
                      (String value) =>
                          FocusScope.of(context).requestFocus(_phoneFocusNode),
                      Validator.validateEmail,
                      focusNode: _emailFocusNode,
                      action: TextInputAction.next,
                    ),
                    textFormField(
                      Constant.phone_edittext_hint,
                      _phoneController,
                      (String value) => FocusScope.of(context)
                          .requestFocus(_addressFocusNode),
                      Validator.validatePhone,
                      type: TextInputType.number,
                      focusNode: _phoneFocusNode,
                      action: TextInputAction.next,
                    ),
                    textFormField(
                      Constant.address_edittext_hint,
                      _addressController,
                      (String value) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      (String value) {},
                      focusNode: _addressFocusNode,
                      action: TextInputAction.next,
                    ),
                    textFormField(
                      Constant.password_edittext_hint,
                      _passwordController,
                      (String value) => FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocusNode),
                      Validator.validatePassword,
                      isObserved: true,
                      focusNode: _passwordFocusNode,
                      action: TextInputAction.next,
                    ),
                    textFormField(
                      Constant.confirm_password_edittext_hint,
                      _confirmPasswordController,
                      (String value) {},
                      isValidConfirmPassword,
                      isObserved: true,
                      focusNode: _confirmPasswordFocusNode,
                      action: TextInputAction.done,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Row(
                      children: <Widget>[
                        Text(Constant.dob_edittext_hint),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(1990),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100))
                                .then((date) {
                              setState(() {
                                _dob = DateFormat('yyyy/MM/dd').format(date);
                              });
                            });
                          },
                          child: Container(
                            constraints:
                                BoxConstraints(minWidth: 170, minHeight: 50),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: <Color>[
                                Colors.orange[300],
                                Colors.orange[200],
                                Colors.orange[100],
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(_dob),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    ListTile(
                        title: const Text('Male'),
                        leading: Radio(
                          onChanged: (int value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          value: 1,
                          groupValue: _gender,
                        )),
                    ListTile(
                        title: const Text('Female'),
                        leading: Radio(
                          onChanged: (int value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          value: 0,
                          groupValue: _gender,
                        )),
                    gradientButton(Constant.register_button, registerPressed),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
