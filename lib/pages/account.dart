import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class MyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Account",
          style: TextStyle(fontSize: 36.0, fontFamily: 'Monospace'),
        ),
        MaterialButton(
          child: Text('Logout'),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/');
            storage.deleteAll();
          },
        )
      ],
    );
  }
}
