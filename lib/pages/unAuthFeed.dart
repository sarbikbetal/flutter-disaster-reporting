import 'package:disaster_reporting/models/info.dart';
import 'package:flutter/material.dart';
import 'package:disaster_reporting/pages/partials/infoCard.dart';
import 'package:disaster_reporting/controllers/infoController.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class UnAuthFeed extends StatefulWidget {
  @override
  _UnAuthFeedState createState() => _UnAuthFeedState();
}

class _UnAuthFeedState extends State<UnAuthFeed> {
  bool _loading = true;
  List _jsonList = List();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            titleSpacing: 6.0,
            pinned: true,
            expandedHeight: 200.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.cyan[600],
                size: 36.0,
              ),
              onPressed: () {
                storage.deleteAll();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            title: Text(
              'Feed',
              style: TextStyle(fontSize: 36.0, color: Colors.cyan[600]),
            ),
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/feed.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
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
      ),
    );
  }

  getdata() async {
    Map<String, dynamic> results = await getAllRecords();

    if (results['data'] != null) {
      _jsonList = jsonDecode(results['data']) as List;
      _jsonList = _jsonList.map((data) => Info.fromJson(data)).toList();
    }

    setState(() {
      _loading = false;
    });
  }
}
