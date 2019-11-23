import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/info.dart';
import 'package:disaster_reporting/controllers/infoController.dart';
import 'package:disaster_reporting/pages/partials/msgBar.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;
  Info _info = Info();
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  var dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    'Add',
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
                        decoration: decorate('Location', Icons.location_on),
                        validator: (value) {
                          return validate(value);
                        },
                        autovalidate: _autoValidate,
                        onSaved: (val) => _info.location = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
                        decoration: decorate('Disaster', Icons.flag),
                        validator: (value) {
                          return validate(value);
                        },
                        autovalidate: _autoValidate,
                        onSaved: (val) => _info.dname = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        enabled: !this._isLoading,
                        controller: dateController,
                        decoration:
                            decorate('Date (YYYY.MM.DD)', Icons.date_range),
                        validator: (value) {
                          return validate(value);
                        },
                        autovalidate: _autoValidate,
                        onSaved: (val) => _info.date = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
                        decoration: decorate('Weather', Icons.wb_sunny),
                        validator: (value) {
                          return validate(value);
                        },
                        autovalidate: _autoValidate,
                        onSaved: (val) => _info.weather = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
                        decoration: decorate('Situation', Icons.landscape),
                        validator: (value) {
                          return validate(value);
                        },
                        autovalidate: _autoValidate,
                        onSaved: (val) => _info.situation = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
                        decoration: decorate('Condition', Icons.landscape),
                        validator: (value) {
                          return validate(value);
                        },
                        autovalidate: _autoValidate,
                        onSaved: (val) => _info.worsen = val,
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
                    child: Text('Add'),
                    onPressed: this._isLoading
                        ? null
                        : () {
                            postRecord();
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        dateController.text =
            "${picked.year.toString()}.${picked.month.toString()}.${picked.day.toString()}";
      });
  }

  postRecord() async {
    String mssg;
    Color color;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        this._isLoading = true;
      });
      String token = await storage.read(key: 'auth_token');

      Map<String, dynamic> result = await addRecord(_info, token);

      if (result['msg'] != null) {
        setState(() {
          this._isLoading = false;
        });
        mssg = result['msg'];
        color = Colors.green[400];
      } else {
        setState(() {
          this._isLoading = false;
        });
        mssg = result['err'];
        color = Colors.red[400];
      }
    } else {
      mssg = "Please fill up all the details";
      color = Colors.red[400];
    }
    final SnackBar snackBar = msgBar(
      mssg,
      color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String validate(value) {
    this._autoValidate = true;
    if (value.isEmpty) {
      return 'Please fill this field';
    }
    return null;
  }

  InputDecoration decorate(String text, IconData icon) {
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
    );
  }
}
