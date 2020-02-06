import 'package:http/http.dart' as http;

class MyAPIClient {
  static http.Client client = http.Client();
  static String accessToken = '';
}
