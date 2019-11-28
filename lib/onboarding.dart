import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class OnBoardingActivity extends StatefulWidget {
  @override
  _OnBoardingActivityState createState() => _OnBoardingActivityState();
}

class _OnBoardingActivityState extends State<OnBoardingActivity> {
  @override
  void initState() {
    super.initState();
    handleNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/onboarding.jpg"),
              alignment: Alignment(0.0, -0.8),
              fit: BoxFit.scaleDown),
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(24.0, 260.0, 24.0, 24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 36.0, 24.0, 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Let's get started...",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.teal[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        'Login to your account or get one to start contributing, or you could just skip this step and still get your feed.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 28.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          coolBtn("Login", "/login"),
                          coolBtn("Register", "/signup")
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.greenAccent[700]),
                              ),
                              onPressed: () {
                                storage.write(key: 'prompted', value: 'true');
                                Navigator.pushReplacementNamed(
                                    context, '/noauth');
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleNavigation() async {
    String prompt = await storage.read(key: 'prompted');
    if (prompt != null) {
      String key = await storage.read(key: 'auth_token');
      if (key == null)
        await Navigator.pushReplacementNamed(context, '/noauth');
      else
        await Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Widget coolBtn(String text, String path) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent[100],
            offset: Offset(0.0, 6.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: FlatButton(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        color: Colors.greenAccent,
        onPressed: () => Navigator.pushNamed(context, path),
        splashColor: Colors.greenAccent[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
