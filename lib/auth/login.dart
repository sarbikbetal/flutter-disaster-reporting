import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _apiKey;
  Agency _user = Agency();

  @override
  Widget build(BuildContext context) {
    getKey();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Login'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text(_apiKey.toString()),
          ),
          Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Licence'),
                      onSaved: (val) => _user.licence = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (val) => setState(() => _user.psswd = val),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Center(
                child: MaterialButton(
                  child: Text('Login'),
                  onPressed: () {
                    final form = _formKey.currentState;
                    form.save();
                    handleLogin();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  getKey() async {
    String key = await storage.read(key: 'auth_token');
    setState(() {
      _apiKey = key;
    });
  }

  handleLogin() async {
    Map<String, dynamic> result = await userSignin(_user);
    if (result['auth_token'] != null) {
      setState(() {
        this._apiKey = result['auth_token'];
      });
      await storage.write(key: 'auth_token', value: _apiKey);
    } else {
      print(result['msg']);
    }
  }
}
