import 'package:flutter/material.dart';
import 'package:disaster_reporting/onboarding.dart';

// Account and Auth
import 'package:disaster_reporting/auth/login.dart';
import 'package:disaster_reporting/auth/signup.dart';

// Main Routes
import 'package:disaster_reporting/pages/feed.dart';
import 'package:disaster_reporting/pages/unAuthFeed.dart';
import 'package:disaster_reporting/pages/contributions.dart';
import 'package:disaster_reporting/pages/account.dart';


// Create storage
// final storage = new FlutterSecureStorage();

void main() => runApp(Landing());

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hello guys',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        // home: Home(),
        routes: {
          '/': (context) => OnBoardingActivity(),
          '/login': (context) => Login(),
          '/signup': (context) => SignUp(),
          '/home': (context) => Feed(),
          '/my': (context) => Contributions(),
          '/account': (context) => MyAccount(),
          '/unreg': (context) => UnAuthFeed(),
        });
  }
}
