import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';
import 'package:disaster_reporting/pages/partials/msgBar.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final _formKey = GlobalKey<FormState>();
  Agency _user;
  String _token;
  bool _isLoading = true;
  bool _invisiblePwd = true;
  bool _autoValidate = false;

  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: _isLoading
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 6.0,
                ),
        ),
        Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
              child: Column(
                children: <Widget>[
                  Text(
                    _user != null ? "Licence: " + _user.licence : " ",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !this._isLoading,
                    controller: nameController,
                    decoration: decorate("Name", Icons.account_box, false),
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
                    controller: addressController,
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
                    controller: contactController,
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
                    decoration: decorate("Old Password", Icons.vpn_key, true),
                    validator: (value) {
                      return validate(value);
                    },
                    autovalidate: _autoValidate,
                    onSaved: (val) => setState(() => _user.old = val),
                    obscureText: this._invisiblePwd,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    enabled: !this._isLoading,
                    decoration: decorate("New Password", Icons.vpn_key, true),
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
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              child: MaterialButton(
                child: Text('Update'),
                onPressed: this._isLoading
                    ? null
                    : () {
                        handleUpdate();
                      },
              ),
            ),
          ],
        ),
        MaterialButton(
          child: Text('Logout'),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
            storage.deleteAll();
          },
        ),
      ],
    );
  }

  void getInfo() async {
    this._token = await storage.read(key: 'auth_token');
    Map<String, dynamic> result = await userInfo(this._user, this._token);
    if (result['err'] != null && mounted) {
      setState(() {
        this._isLoading = false;
      });
      final SnackBar snackBar = msgBar(
        result['err'],
        Colors.red[400],
      );

      Scaffold.of(context).showSnackBar(snackBar);
    }
    if (mounted) {
      this.setState(() {
        this._isLoading = false;
        this._user = Agency(
          licence: result['licence'],
          name: result['name'],
          address: result['address'],
          contact: result['contact'],
        );
        this.nameController.text = result['name'];
        this.addressController.text = result['address'];
        this.contactController.text = result['contact'].toString();
      });
    }
  }

  void handleUpdate() async {
    String mssg;
    Color color;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        this._isLoading = true;
      });

      Map<String, dynamic> result = await updateUser(this._user, this._token);

      if (result['err'] != null) {
        setState(() {
          this._isLoading = false;
        });
        mssg = result['err'];
        color = Colors.red[400];
      } else {
        this.setState(() {
          this._isLoading = false;
          this._user = Agency(
            licence: result['licence'],
            name: result['name'],
            address: result['address'],
            contact: result['contact'],
          );
          this.nameController.text = result['name'];
          this.addressController.text = result['address'];
          this.contactController.text = result['contact'].toString();
        });
        mssg = "User updated successfully";
        color = Colors.green[400];
      }
    } else {
      mssg = "Please fill up all the details";
      color = Colors.red[400];
    }

    final SnackBar snackBar = msgBar(
      mssg,
      color,
    );
    Scaffold.of(context).showSnackBar(snackBar);
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
