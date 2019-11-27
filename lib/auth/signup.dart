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
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/signup_bg.png"),
                  alignment: Alignment(0.0, -0.9),
                  fit: BoxFit.scaleDown),
            ),
            child: ListView(
              children: <Widget>[
                Center(
                    child: _isLoading
                        ? LinearProgressIndicator()
                        : SizedBox(height: 6.0)),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 160.0, 24.0, 0.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    elevation: 5.0,
                    child: Builder(
                      builder: (context) => Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 24.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    iconSize: 36.0,
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Text(
                                    ' Register',
                                    style: TextStyle(fontSize: 36.0),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 28.0,
                                  ),
                                  TextFormField(
                                    enabled: !this._isLoading,
                                    decoration: decorate(
                                        "Name", Icons.account_box, false),
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
                                    decoration: decorate(
                                        "Licence", Icons.credit_card, false),
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
                                    decoration:
                                        decorate("Address", Icons.home, false),
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
                                    decoration:
                                        decorate("Contact", Icons.phone, false),
                                    validator: (value) {
                                      return validate(value);
                                    },
                                    autovalidate: _autoValidate,
                                    onSaved: (val) =>
                                        _user.contact = int.parse(val),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  TextFormField(
                                    enabled: !this._isLoading,
                                    decoration: decorate(
                                        "Password", Icons.vpn_key, true),
                                    validator: (value) {
                                      return validate(value);
                                    },
                                    autovalidate: _autoValidate,
                                    onSaved: (val) =>
                                        setState(() => _user.psswd = val),
                                    obscureText: this._invisiblePwd,
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      MaterialButton(
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                          ),
                                        ),
                                        onPressed: this._isLoading
                                            ? null
                                            : () {
                                                handleSignup(context);
                                              },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
        Navigator.pop(context);
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
