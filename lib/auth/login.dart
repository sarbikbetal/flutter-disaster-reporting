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
  String _token;
  Agency _user = Agency();
  bool _invisiblePwd = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 72.0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 48.0,
                      color: Colors.red[400],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(_token.toString()),
            ),
            Builder(
              builder: (context) => Form(
                key: _formKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal[100],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                          ),
                          labelText: 'Licence',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        onSaved: (val) => _user.licence = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          suffixIcon: IconButton(
                              color: Colors.black54,
                              padding: EdgeInsets.all(1.0),
                              icon: this._invisiblePwd
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  this._invisiblePwd = !this._invisiblePwd;
                                });
                              }),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal[100],
                            ),
                          ),
                          focusColor: Colors.blue,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onSaved: (val) => setState(() => _user.psswd = val),
                        obscureText: this._invisiblePwd,
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
                      // _settingModalBottomSheet(context);
                      handleLogin();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  getKey() async {
    String key = await storage.read(key: 'auth_token');
    setState(() {
      _token = key;
    });
  }

  handleLogin() async {
    Map<String, dynamic> result = await userSignin(_user);
    if (result['auth_token'] != null) {
      setState(() {
        this._token = result['auth_token'];
      });
      await storage.write(key: 'auth_token', value: _token);
    } else {
      setState(() {
        this._token = result['msg'];
      });
      await storage.delete(key: 'auth_token');
    }
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text('Music'),
                  onTap: () => {}),
              new ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () => {},
              ),
            ],
          ),
        );
      });
}
