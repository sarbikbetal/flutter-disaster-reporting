import 'package:disaster_reporting/models/info.dart';
import 'package:flutter/material.dart';
import 'package:disaster_reporting/pages/partials/infoCard.dart';
import 'package:disaster_reporting/controllers/infoController.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Contributions extends StatefulWidget {
  @override
  _ContributionsState createState() => _ContributionsState();
}

class _ContributionsState extends State<Contributions> {
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
              'Additions',
              style: TextStyle(fontSize: 34.0, color: Colors.green[600]),
            ),
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/contri.jpg',
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
                  : _jsonList.isEmpty
                      ? [
                          SizedBox(
                            height: 64.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "You have not made any contributions yet..",
                              style: TextStyle(
                                  fontSize: 22.0, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              'assets/images/nocontrib.jpg',
                              fit: BoxFit.scaleDown,
                            ),
                          )
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
    _jsonList = null;
    Map<String, dynamic> results = await getMyRecords();
    // InfoProvider db;
    // await db.open("infos.db");
    // await db.getAllRecord();
    // await db.close();

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
