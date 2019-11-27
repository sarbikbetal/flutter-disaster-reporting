import 'package:flutter/material.dart';

// Account and Auth
import 'package:disaster_reporting/auth/login.dart';
import 'package:disaster_reporting/auth/signup.dart';

// Main Routes
import 'package:disaster_reporting/onboarding.dart';
import 'package:disaster_reporting/pages/mainPage.dart';
import 'package:disaster_reporting/pages/unAuthFeed.dart';
import 'package:disaster_reporting/pages/addRecord.dart';

// Create storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

void main() => runApp(Landing());

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        buttonTheme: ButtonThemeData(
          minWidth: 140.0,
          buttonColor: Colors.greenAccent,
        ),
      ),
      routes: {
        '/': (context) => OnBoardingActivity(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/home': (context) => PageWrapper(),
        '/noauth': (context) => UnAuthFeed(),
        '/add': (context) => AddRecord(),
      },
    );
  }
}
