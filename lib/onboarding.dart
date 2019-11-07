import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class OnBoardingActivity extends StatefulWidget {
  @override
  _OnBoardingActivityState createState() => _OnBoardingActivityState();
}

class _OnBoardingActivityState extends State<OnBoardingActivity> {
  String _token;

  @override
  void initState() {
    super.initState();
    handleNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 200.0,
              leading: Icon(Icons.arrow_back),
              title: Text('Lifeline'),
              flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 64.0,
                    ),
                    Text(
                      'A modern way to let people get deeper insights about natural disasters happening all around.',
                      style: TextStyle(fontSize: 20.0, color: Colors.grey[350]),
                    )
                  ],
                ),
              )),
              floating: true,
              snap: true,
              shape: BeveledRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20.0)),
              )),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              SizedBox(
                height: 220.0,
                child: Center(
                  child: Text((this._token != null) ? this._token : ''),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          OutlineButton(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                " Login ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            color: Colors.teal,
                            splashColor: Colors.green[400],
                            highlightedBorderColor: Colors.green[400],
                            borderSide: BorderSide(
                              color: Colors.teal[300],
                              width: 2.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                          OutlineButton(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/signup'),
                            color: Colors.teal,
                            splashColor: Colors.green[400],
                            highlightedBorderColor: Colors.green[400],
                            borderSide: BorderSide(
                              color: Colors.teal[300],
                              width: 2.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                              child: Text(
                                "Skip",
                                style: TextStyle(color: Colors.black54),
                              ),
                              onPressed: () {
                                storage.write(key: 'prompted', value: 'true');
                                Navigator.pushNamed(
                                    context, '/noauth');
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  void handleNavigation() async {
    String prompt = await storage.read(key: 'prompted');
    if (prompt != null) {
      String key = await storage.read(key: 'auth_token');
      if (key == null)
        await Navigator.pushNamed(context, '/noauth');
      else
        await Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
}
