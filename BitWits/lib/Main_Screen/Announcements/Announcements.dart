import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  // String textValue = "Hello World!";
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
  //   Future.delayed(Duration(seconds: 2));

  //   firebaseMessaging.configure(
  //     // ignore: missing_return
  //     onLaunch: (Map<String, dynamic> msg) {
  //       print(" onLaunch called ");
  //     },
  //     // ignore: missing_return
  //     onResume: (Map<String, dynamic> msg) {
  //       print(" onResume called ");
  //     },
  //     // ignore: missing_return
  //     onMessage: (Map<String, dynamic> msg) {
  //       print(" onMessage called ");
  //     },
  //   );
  //   firebaseMessaging.requestNotificationPermissions(
  //       const IosNotificationSettings(sound: true, alert: true, badge: true));
  //   firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings setting) {
  //     print('IOS Setting Registed');
  //   });
  //   //work area
  //   firebaseMessaging.getToken().then((token) {
  //     update(token);
  //   });
  // }

  // update(String token) {
  //   print(token);
  //   textValue = token;
  //   setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {})
          ],
      ),
    );
  }
}
