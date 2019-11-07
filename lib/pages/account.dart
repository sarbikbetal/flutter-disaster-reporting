import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/user.dart';
import 'package:disaster_reporting/controllers/userController.dart';
import 'package:flutter/services.dart';

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
  String _message = '';

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
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: _isLoading
                ? LinearProgressIndicator()
                : Text(
                    this._message,
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 16.0,
                    ),
                  ),
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
                    enabled: !this._isLoading,
                    controller: addressController,
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
                    enabled: !this._isLoading,
                    controller: contactController,
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
                    enabled: !this._isLoading,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
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
                    onSaved: (val) => setState(() => _user.old = val),
                    obscureText: this._invisiblePwd,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                   TextFormField(
                    enabled: !this._isLoading,
                    decoration: InputDecoration(
                      labelText: 'New Password',
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
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              child: MaterialButton(
                child: Text('Update'),
                onPressed: this._isLoading
                    ? null
                    : () {
                        final form = _formKey.currentState;
                        form.save();
                        
                      },
              ),
            ),
          ],
        ),
        MaterialButton(
          child: Text('Logout'),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/');
            storage.deleteAll();
          },
        ),
      ],
    );
  }

  void getInfo() async {
    this._token = await storage.read(key: 'auth_token');
    Map<String, dynamic> result = await userInfo(this._user, this._token);
    if (result['msg'] != null) {
      setState(() {
        this._message = result['msg'];
        this._isLoading = false;
      });
    }
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
    print(result);
  }
}
