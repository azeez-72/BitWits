import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  final Firestore _db = Firestore.instance;

  String textValue = "Hello World!";
  FirebaseUser currentUser;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;

  _saveDeviceToken() async {
    String fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      var token = _db.collection('DeviceTokens').document(fcmToken);
      print('device token : $fcmToken');
      await token.setData({
        'device_token': fcmToken,
      });
    }
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
      },
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
//    final String body = notification['body'];
    final String mMessage = data['message'];
    print("Title: $title,  message: $mMessage");
    setState(() {
      Message m = Message(title, mMessage);
      _messages.add(m);
    });
  }

  @override
  void initState() {
    //   Future.delayed(Duration(seconds: 2));
    super.initState();
    _messages = List<Message>();
    _saveDeviceToken();
//    registeredCurrentUser();
    Future.delayed(Duration(seconds: 2));
    _configureFirebaseListeners();

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    //work area
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.info_outline),onPressed: (){},),
        title: Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: ListView.builder(
        itemCount: null == _messages ? 0 : _messages.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                _messages[index].message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Message {
  String title;
//  String body;
  String message;
  Message(title, message) {
    this.title = title;
//    this.body = body;
    this.message = message;
  }
}
//body: $body,
