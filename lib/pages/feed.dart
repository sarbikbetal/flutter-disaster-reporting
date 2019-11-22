import 'package:disaster_reporting/models/info.dart';
import 'package:flutter/material.dart';
import 'package:disaster_reporting/pages/partials/infoCard.dart';
import 'package:disaster_reporting/controllers/infoController.dart';
import 'dart:convert';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
              'Feed',
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
    Map<String, dynamic> results = await getAllRecords();

    if (results['data'] != null) {
      _jsonList = jsonDecode(results['data']) as List;
      _jsonList = _jsonList.map((data) => Info.fromJson(data)).toList();
    }

    if (mounted)
      setState(() {
        _loading = false;
      });
  }
}
