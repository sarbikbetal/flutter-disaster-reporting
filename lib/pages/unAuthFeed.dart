import 'package:flutter/material.dart';

class UnAuthFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Unregistered'),
      ),
      body: Container(
        child: Center(
          child: Text('NologinWrapper'),
        ),
      ),
    );
  }
}
