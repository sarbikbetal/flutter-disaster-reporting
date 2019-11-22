import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/info.dart';

import 'package:disaster_reporting/controllers/infoController.dart';
import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formKey = GlobalKey<FormState>();
  String _message = '';
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        enabled: !this._isLoading,
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
                          labelText: 'Location',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        onSaved: (val) => _info.location = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
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
                          labelText: 'Disaster',
                          prefixIcon: Icon(Icons.flag),
                        ),
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
                          labelText: 'Date (YYYY.MM.DD)',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        onSaved: (val) => _info.date = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
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
                          labelText: 'Weather',
                          prefixIcon: Icon(Icons.wb_sunny),
                        ),
                        onSaved: (val) => _info.weather = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
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
                          labelText: 'Situation',
                          prefixIcon: Icon(Icons.landscape),
                        ),
                        onSaved: (val) => _info.situation = val,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        enabled: !this._isLoading,
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
                          labelText: 'Condition',
                          prefixIcon: Icon(Icons.landscape),
                        ),
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
                            final form = _formKey.currentState;
                            form.save();
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
    setState(() {
      this._isLoading = true;
    });
    String token = await storage.read(key: 'auth_token');
    Map<String, dynamic> result = await addRecord(_info, token);
    if (result['msg'] != null) {
      setState(() {
        this._message = result['msg'];
        this._isLoading = false;
      });
      // Navigator.pop(context, '/dashboard');
    } else {
      setState(() {
        this._message = result['err'];
        this._isLoading = false;
      });
    }
  }
}
