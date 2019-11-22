import 'package:disaster_reporting/models/info.dart';
import 'package:flutter/material.dart';
import 'package:disaster_reporting/pages/partials/infoCard.dart';
import 'package:disaster_reporting/controllers/infoController.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Contributions extends StatefulWidget {
  @override
  _ContributionsState createState() => _ContributionsState();
}

class _ContributionsState extends State<Contributions> {
  bool _loading = true;
  List _jsonList = List();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            titleSpacing: 24.0,
            pinned: true,
            expandedHeight: 140.0,
            title: Text(
              'Records',
              style: TextStyle(fontSize: 36.0),
            ),
            floating: true,
            shape: BeveledRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20.0)),
            )),
        SliverList(
          delegate: SliverChildListDelegate(
            _loading
                ? <Widget>[
                    SizedBox(
                      height: 220.0,
                    ),
                    Center(child: CircularProgressIndicator())
                  ]
                : _jsonList
                    .map((data) => InfoCard(
                          info: data,
                        ))
                    .toList(),
          ),
        )
      ],
    );
  }

  getdata() async {
    String token = await storage.read(key: 'auth_token');
    Map<String, dynamic> results = await getMyRecords(token);

    if (results['data'] != null) {
      _jsonList = jsonDecode(results['data']) as List;
      _jsonList = _jsonList.map((data) => Info.fromJson(data)).toList();
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}
