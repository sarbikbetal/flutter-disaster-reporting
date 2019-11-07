import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class UnAuthFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Unauthenticated",
              style: TextStyle(
                fontSize: 36.0,
              ),
            ),
            MaterialButton(
              child: Text("Go back"),
              onPressed: () {
                storage.deleteAll();
                Navigator.popAndPushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
