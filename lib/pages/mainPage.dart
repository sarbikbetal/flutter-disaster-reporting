import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

// Main Routes
import 'package:disaster_reporting/pages/feed.dart';
import 'package:disaster_reporting/pages/contributions.dart';
import 'package:disaster_reporting/pages/account.dart';
import 'package:disaster_reporting/pages/unAuthFeed.dart';

class PageWrapper extends StatefulWidget {
  @override
  _PageWrapperState createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  int _pageIndex = 1;
  final _controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: this._controller,
        children: <Widget>[Contributions(), Feed(), MyAccount()],
        onPageChanged: (index) => setState(() {
          this._pageIndex = index;
        }),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 42.0),
        child: BottomNavyBar(
          selectedIndex: this._pageIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            this._pageIndex = index;
            _controller.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
            );
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.assignment_turned_in),
              title: Text('Records'),
              activeColor: Colors.green,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.indigo,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Account'),
              activeColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
