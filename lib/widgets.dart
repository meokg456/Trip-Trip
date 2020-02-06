import 'package:flutter/material.dart';

Widget gradientButton(String title, Function pressed) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    padding: EdgeInsets.all(0),
    onPressed: pressed,
    child: Container(
      constraints: BoxConstraints(minWidth: 98, minHeight: 50),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Colors.orange[300],
          Colors.orange[200],
          Colors.orange[100],
        ]),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(title),
    ),
  );
}

Widget textFormField(
  String hint,
  TextEditingController textEditingController,
  Function submittedFunction,
  Function validateFunction, {
  TextInputType type = TextInputType.text,
  bool isObserved = false,
  FocusNode focusNode,
  TextInputAction action,
}) {
  return TextFormField(
    focusNode: focusNode,
    controller: textEditingController,
    keyboardType: type,
    textInputAction: action,
    validator: validateFunction,
    onFieldSubmitted: submittedFunction,
    decoration: InputDecoration(hintText: hint),
    obscureText: isObserved,
  );
}
