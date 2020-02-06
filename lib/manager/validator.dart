import 'package:trip_trip/manager/constant.dart';

class Validator {
  static String validateEmail(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) return null;
    return Constant.email_edittext_error;
  }

  static String validateUsername(String username) {
    if (username.isEmpty) {
      return Constant.username_edittext_error;
    }
    return null;
  }

  static String validatePassword(String password) {
    if (password.length < 8) {
      return Constant.password_edittext_error;
    }
    return null;
  }

  static String validatePhone(String phone) {
    if (phone.length >= 10) return null;
    return Constant.phone_edittext_error;
  }
}
