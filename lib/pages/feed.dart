import 'package:disaster_reporting/models/info.dart';
import 'package:flutter/material.dart';
import 'package:disaster_reporting/pages/partials/infoCard.dart';
import 'package:disaster_reporting/controllers/infoController.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final RefreshController _refreshController = RefreshController();
  bool _loading = true;
  List _jsonList = List();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: () async {
        await getdata();
        _refreshController.refreshCompleted();
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            titleSpacing: 24.0,
            pinned: true,
            expandedHeight: 200.0,
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
    setState(() {
      _loading = true;
    });

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
