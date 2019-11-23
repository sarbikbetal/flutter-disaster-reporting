import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';
import 'package:disaster_reporting/pages/partials/msgBar.dart';
import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  Agency _user = Agency();
  bool _invisiblePwd = true;
  bool _autoValidate = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                                decorate("Name", Icons.account_box, false),
                            validator: (value) {
                              return validate(value);
                            },
                            autovalidate: _autoValidate,
                            onSaved: (val) => _user.name = val,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            enabled: !this._isLoading,
                            decoration:
                                decorate("Licence", Icons.credit_card, false),
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
                            decoration: decorate("Address", Icons.home, false),
                            validator: (value) {
                              return validate(value);
                            },
                            autovalidate: _autoValidate,
                            onSaved: (val) => _user.address = val,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            enabled: !this._isLoading,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            decoration: decorate("Contact", Icons.phone, false),
                            validator: (value) {
                              return validate(value);
                            },
                            autovalidate: _autoValidate,
                            onSaved: (val) => _user.contact = int.parse(val),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            enabled: !this._isLoading,
                            decoration:
                                decorate("Password", Icons.vpn_key, true),
                            validator: (value) {
                              return validate(value);
                            },
                            autovalidate: _autoValidate,
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
                        onPressed: this._isLoading
                            ? null
                            : () {
                                handleSignup(context);
                              },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  handleSignup(cntxt) async {
    String mssg;
    Color color;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        this._isLoading = true;
      });
      Map<String, dynamic> result = await userSignup(_user);
      if (result['auth_token'] != null) {
        setState(() {
          this._isLoading = false;
        });
        mssg = "User registered successfully";
        color = Colors.green[400];
        await storage.write(key: 'auth_token', value: result['auth_token']);
        await storage.write(key: 'prompted', value: 'true');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          this._isLoading = false;
        });
        mssg = result['err'];
        color = Colors.red[400];
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
