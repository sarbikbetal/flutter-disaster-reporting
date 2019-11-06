import 'package:flutter/material.dart';

class UnAuthFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Unauthenticated",
          style: TextStyle(
            fontSize: 36.0,
          ),
        ),
      ),
    );
  }
}
