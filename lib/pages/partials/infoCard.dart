import 'package:flutter/material.dart';
import 'package:disaster_reporting/models/info.dart';

class InfoCard extends StatefulWidget {
  final Info info;

  InfoCard({this.info});

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        elevation: 2.0,
        child: InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInCubic,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.info.dname,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      widget.info.location,
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.info.date,
                      style: TextStyle(
                        color: Colors.black45,
                        height: 1.3,
                      ),
                    ),
                    _expanded
                        ? Text(
                            'Conditions',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                height: 2.0),
                          )
                        : SizedBox(),
                    _expanded
                        ? Text(
                            'Weather: ' + widget.info.weather,
                            style:
                                TextStyle(color: Colors.grey[600], height: 1.2),
                          )
                        : SizedBox(),
                    _expanded
                        ? Text(
                            'Concerns: ' + widget.info.worsen,
                            style:
                                TextStyle(color: Colors.grey[600], height: 1.2),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
