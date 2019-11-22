import 'package:disaster_reporting/models/info.dart';
import 'dart:convert';
import 'package:http/http.dart';

String url = 'https://srbk-mini-project.herokuapp.com/info/';

Future<Map<String, dynamic>> getAllRecords() async {
  String route = url + 'all';

  Response response;
  try {
    response = await get(route);
  } catch (e) {}

  Map<String, dynamic> result;
  if (response == null) {
    result = {"msg": "No internet connection."};
  } else if (response.statusCode == 401 || response.statusCode == 400) {
    result = {"msg": "Session expired, please login again."};
  } else {
    result = {"data": response.body};
  }
  return result;
}

Future<Map<String, dynamic>> getMyRecords(String token) async {
  String route = url + 'my';
  Map<String, String> headers = {"Authorization": "Bearer " + token};

  Response response;
  try {
    response = await get(route, headers: headers);
  } catch (e) {
    print(e);
  }

  Map<String, dynamic> result;
  if (response == null) {
    result = {"msg": "No internet connection."};
  } else if (response.statusCode == 400) {
    result = {"msg": "Session expired, please login again."};
  } else {
    result = {"data": response.body};
  }
  return result;
}

Future<Map<String, dynamic>> addRecord(Info info, String token) async {
  String route = url + 'newPost';
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer " + token
  };
  Map<String, dynamic> userMap = {
    'location': info.location,
    'date': info.date,
    'D_code': info.dname,
    'weather': info.weather,
    'situation': info.situation,
    'worsen': info.worsen
  };

  String json = jsonEncode(userMap);
  Response response = await post(route, headers: headers, body: json);

  Map<String, dynamic> result;

  if (response == null) {
    result = {"msg": "No internet connection"};
  } else if (response.statusCode == 200) {
    result = jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    result = {"err": "Session expired, please login again."};
  } else
    result = {"err": "Error adding record"};
  return result;
}
