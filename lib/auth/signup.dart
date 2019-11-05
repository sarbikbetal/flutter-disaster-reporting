import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';
import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _token;
  Agency _user = Agency();
  bool _invisiblePwd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Register',
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
                              color: Colors.green,
                            ),
                          ),
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.account_box),
                        ),
                        onSaved: (val) => _user.name = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal[100],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
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
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal[100],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home),
                        ),
                        onSaved: (val) => _user.address = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal[100],
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          labelText: 'Contact',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        onSaved: (val) => _user.contact = int.parse(val),
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
                              color: Colors.black87,
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                        onSaved: (val) => setState(() => _user.psswd = val),
                        obscureText: this._invisiblePwd,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                  child: MaterialButton(
                    child: Text('Register'),
                    onPressed: () {
                      final form = _formKey.currentState;
                      form.save();
                      handleLogin();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  handleLogin() async {
    Map<String, dynamic> result = await userSignup(_user);
    if (result['auth_token'] != null) {
      await storage.write(key: 'auth_token', value: _token);
      await storage.write(key: 'prompted', value: 'true');
    } else {
      await storage.deleteAll();
    }
  }
}
