import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

// Main Routes
import 'package:disaster_reporting/pages/feed.dart';
import 'package:disaster_reporting/pages/contributions.dart';
import 'package:disaster_reporting/pages/account.dart';

class PageWrapper extends StatefulWidget {
  @override
  _PageWrapperState createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  int _pageIndex = 1;
  final _controller = PageController(initialPage: 1);
  List<Widget> _fabs(context) => [
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
        ),
        null,
        null,
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: PageView(
          controller: this._controller,
          children: <Widget>[Contributions(), Feed(), MyAccount()],
          onPageChanged: (index) {
            setState(() {
              this._pageIndex = index;
            });
          },
        ),
      ),
      floatingActionButton: _fabs(context)[_pageIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 42.0),
        child: BottomNavyBar(
          backgroundColor: Colors.grey[50],
          selectedIndex: this._pageIndex,
          showElevation: false,
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
              activeColor: Colors.cyan,
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
