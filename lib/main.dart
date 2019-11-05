import 'package:flutter/material.dart';
import 'package:disaster_reporting/onboarding.dart';

// Account and Auth
import 'package:disaster_reporting/auth/login.dart';
import 'package:disaster_reporting/auth/signup.dart';

// Main Routes
import 'package:disaster_reporting/pages/mainPage.dart';

// Create storage
// final storage = new FlutterSecureStorage();

void main() => runApp(Landing());

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hello guys',
        theme: ThemeData(
            primarySwatch: Colors.green,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              buttonColor: Colors.red,
            )),
        // home: Home(),
        routes: {
          '/': (context) => OnBoardingActivity(),
          '/login': (context) => Login(),
          '/signup': (context) => SignUp(),
          '/dashboard': (context) => PageWrapper(),
        });
  }
}
