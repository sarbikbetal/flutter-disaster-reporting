import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:disaster_reporting/pages/staging.dart';
import 'package:disaster_reporting/pages/noLogin.dart';
// import 'package:disaster_reporting/pages/loginFeed.dart';

// Create storage
// final storage = new FlutterSecureStorage();

void main() => runApp(Landing());

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        // home: Home(),
        routes: {
          '/': (context) => Staging(),
          '/noLogin': (context) => NoLoginApp(),
          // '/dashboard': (context) => LoginFeed()
        });
  }
}
