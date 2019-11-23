import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';
import 'package:disaster_reporting/pages/partials/msgBar.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Agency _user = Agency();
  bool _invisiblePwd = true;
  bool _isLoading = false;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: ListView(
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
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                    child: _isLoading
                        ? LinearProgressIndicator()
                        : SizedBox(height: 6.0)),
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
                          enabled: !this._isLoading,
                          decoration:
                              decorate("License", Icons.credit_card, false),
                          validator: (value) {
                            return validate(value);
                          },
                          autovalidate: _autoValidate,
                          onSaved: (val) => _user.licence = val,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          enabled: !this._isLoading,
                          decoration: decorate("Password", Icons.vpn_key, true),
                          validator: (value) {
                            return validate(value);
                          },
                          autovalidate: _autoValidate,
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
                      onPressed: this._isLoading
                          ? null
                          : () {
                              handleLogin(context);
                            },
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  handleLogin(cntxt) async {
    String mssg;
    Color color;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        this._isLoading = true;
      });
      Map<String, dynamic> result = await userSignin(_user);
      if (result['auth_token'] != null) {
        mssg = 'Welcome Back';
        color = Colors.green[400];
        setState(() {
          this._isLoading = false;
        });
        await storage.write(key: 'auth_token', value: result['auth_token']);
        await storage.write(key: 'prompted', value: 'true');
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        mssg = result['err'];
        color = Colors.red[400];
        setState(() {
          this._isLoading = false;
        });
        storage.deleteAll();
      }
    } else {
      mssg = "Please fill up all the details";
      color = Colors.red[400];
    }

    final SnackBar snackBar = msgBar(
      mssg,
      color,
    );
    Scaffold.of(cntxt).showSnackBar(snackBar);
  }

  String validate(value) {
    this._autoValidate = true;
    if (value.isEmpty) {
      return 'Please fill this field';
    }
    return null;
  }

  InputDecoration decorate(String text, IconData icon, bool password) {
    return InputDecoration(
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
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepOrange[200],
        ),
      ),
      labelText: text,
      prefixIcon: Icon(icon),
      suffixIcon: password
          ? IconButton(
              color: Colors.black54,
              padding: EdgeInsets.all(1.0),
              icon: this._invisiblePwd
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  this._invisiblePwd = !this._invisiblePwd;
                });
              })
          : null,
    );
  }
}
