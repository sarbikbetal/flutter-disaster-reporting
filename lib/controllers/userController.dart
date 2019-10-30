import 'package:disaster_reporting/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart';

Future<Map<String, dynamic>> userSignin(Agency user) async {
  String url = 'https://srbk-mini-project.herokuapp.com/user/signin';
  Map<String, String> headers = {"Content-type": "application/json"};

  Map<String, dynamic> userMap = {
    'licence': user.licence,
    'psswd': user.psswd,
  };

  String json = jsonEncode(userMap);
  Response response = await post(url, headers: headers, body: json);
  Map<String, dynamic> result = jsonDecode(response.body);
  return result;
}
