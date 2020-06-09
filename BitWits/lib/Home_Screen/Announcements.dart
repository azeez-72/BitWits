import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Announcements extends StatefulWidget {
  static String id = "announcements";
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  String textValue = 'Hello World  !';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  // ignore: must_call_super
  void initState() {
    firebaseMessaging.configure(
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ");
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ");
      },
      // ignore: missing_return
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  update(String token) {
    print(token);
    textValue = token;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Classmates",
              style: TextStyle(letterSpacing: 1, fontSize: 21)),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              Center(
                child: new Text(
                  textValue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
