import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';
import 'package:disaster_reporting/pages/partials/msgBar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  final RefreshController _refreshController = RefreshController();
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
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/account.jpg"),
            alignment: Alignment(0.0, -1.0),
            fit: BoxFit.scaleDown),
      ),
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () {
          getInfo();
          _refreshController.refreshCompleted();
        },
        child: ListView(
          children: <Widget>[
            Center(
              child: _isLoading
                  ? LinearProgressIndicator()
                  : SizedBox(height: 6.0),
            ),
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
                              horizontal: 24.0, vertical: 4.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 16.0),
                              Text(
                                _user != null
                                    ? "Licence: " + _user.licence
                                    : "Licence:",
                                style: TextStyle(fontSize: 22.0),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                enabled: !this._isLoading,
                                controller: nameController,
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
                                controller: addressController,
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
                                controller: contactController,
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
                                    "Old Password", Icons.vpn_key, true),
                                validator: (value) {
                                  return validate(value);
                                },
                                autovalidate: _autoValidate,
                                onSaved: (val) =>
                                    setState(() => _user.old = val),
                                obscureText: this._invisiblePwd,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                enabled: !this._isLoading,
                                decoration: decorate(
                                    "New Password", Icons.vpn_key, true),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  MaterialButton(
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.red[400],
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/');
                                      storage.deleteAll();
                                    },
                                  ),
                                  MaterialButton(
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.amber[600],
                                      ),
                                    ),
                                    onPressed: this._isLoading
                                        ? null
                                        : () {
                                            handleUpdate();
                                          },
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  void getInfo() async {
    this.setState(() {
      this._isLoading = true;
    });
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
