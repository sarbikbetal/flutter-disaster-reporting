import 'package:disaster_reporting/models/info.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
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

Future<Map<String, dynamic>> getMyRecords() async {
  String route = url + 'my';
  String token = await storage.read(key: 'auth_token');
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

Future<Map<String, dynamic>> addRecord(Info info) async {
  String route = url + 'newPost';
  String token = await storage.read(key: 'auth_token');
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
  Response response;

  try {
    response = await post(route, headers: headers, body: json);
  } catch (e) {
    response = null;
  }

  Map<String, dynamic> result;

  if (response == null) {
    result = {"msg": "No internet connection, added locally"};
    await storeLocal(info);
  } else if (response.statusCode == 200) {
    result = jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    result = {"err": "Session expired, please login again."};
  } else
    result = {"err": "Error adding record"};
  return result;
}

Future<Null> storeLocal(Info info) async {
  InfoProvider db = InfoProvider();
  await db.open("infos.db");
  await db.insert(info);
  await db.close();
  return;
}
