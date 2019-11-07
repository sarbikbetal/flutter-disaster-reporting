import 'package:disaster_reporting/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart';

String url = 'https://srbk-mini-project.herokuapp.com/user/';

Future<Response> reqPost(route, headers, json) async {
  try {
    return await post(route, headers: headers, body: json);
  } catch (e) {
    return null;
  }
}

Future<Map<String, dynamic>> userSignin(Agency user) async {
  String route = url + 'signin';
  Map<String, String> headers = {"Content-type": "application/json"};

  Map<String, dynamic> userMap = {
    'licence': user.licence,
    'psswd': user.psswd,
  };

  String json = jsonEncode(userMap);
  Response response = await reqPost(route, headers, json);

  Map<String, dynamic> result;
  if (response == null) {
    result = {"msg": "No internet connection"};
  } else if (response.statusCode == 200) {
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
  Response response = await reqPost(route, headers, json);

  Map<String, dynamic> result;

  if (response == null) {
    result = {"msg": "No internet connection"};
  } else if (response.statusCode == 200) {
    result = jsonDecode(response.body);
  } else
    result = {"msg": "Error registering user"};
  return result;
}

Future<Map<String, dynamic>> userInfo(Agency user, String token) async {
  String route = url + 'info';
  Map<String, String> headers = {"Authorization": "Bearer " + token};

  Response response;
  try {
    response = await get(route, headers: headers);
  } catch (e) {
  }

  Map<String, dynamic> result;
  if (response == null) {
    result = {"msg": "No internet connection."};
  } else if (response.statusCode == 401 || response.statusCode == 400) {
    result = {"msg": "Session expired, please login again."};
  } else {
    result = jsonDecode(response.body);
  }
  return result;
}
