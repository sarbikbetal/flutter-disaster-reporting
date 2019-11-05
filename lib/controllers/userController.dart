import 'package:disaster_reporting/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart';

String url = 'https://srbk-mini-project.herokuapp.com/user/';

Future<Map<String, dynamic>> userSignin(Agency user) async {
  String route = url + 'signin';
  Map<String, String> headers = {"Content-type": "application/json"};

  Map<String, dynamic> userMap = {
    'licence': user.licence,
    'psswd': user.psswd,
  };

  String json = jsonEncode(userMap);
  Response response = await post(route, headers: headers, body: json);
  Map<String, dynamic> result;
  if (response.statusCode == 200) {
    result = jsonDecode(response.body);
  } else
    result = {"msg": "Invalid username/password"};
  return result;
}

Future<Map<String, dynamic>> userSignup(Agency user) async {
  String route = url + 'signup';
  Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, dynamic> userMap = {
    'name': user.name,
    'licence': user.licence,
    'address': user.address,
    'contact': user.contact,
    'psswd': user.psswd,
  };

  String json = jsonEncode(userMap);
  Response response = await post(route, headers: headers, body: json);
  Map<String, dynamic> result;
  if (response.statusCode == 200) {
    result = jsonDecode(response.body);
  } else
    result = jsonDecode(response.body);
  return result;
}
