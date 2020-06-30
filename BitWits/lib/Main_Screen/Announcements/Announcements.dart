import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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

  final Map<String, bool> _visible = {
    "COVID-19": false,
    "DEGREE": false,
    "EXAM_SECTION": false,
    "NOTICE": false,
    "COMPONENT": false,
  };

  void toggleVisibility(String a) {
    setState(() {
      _visible[a] = !_visible[a];
    });
  }
  int _itemCount = 0;
  var jsonResponse;

  Future<void> getlinks() async {
    String url = "http://college-scrapper.herokuapp.com";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body);
        _itemCount = jsonResponse.length;
      });
      print("Number of links found : $_itemCount.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "Announcements",
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2265B3)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "All the announcements added to the 'NEWS AND NOTIFICATIONS' column of VJTI website can be viewed on this page.",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "Click on the links provided to view corresponding PDF.",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    //   Future.delayed(Duration(seconds: 2));
    super.initState();
    getlinks();
    _messages = List<Message>();
    _saveDeviceToken();
//    registeredCurrentUser();
    Future.delayed(Duration(seconds: 2));
    _configureFirebaseListeners();

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registered');
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
        leading: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            _settingModalBottomSheet(context);
          },
        ),
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
              icon: Icon(Icons.add, size: 30),
             // onPressed : () {}
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "COVID-19",
                          style: TextStyle(fontSize: 24.0),
                        )),
                    IconButton(
                      icon: Icon(_visible["COVID-19"] == false
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                      onPressed: () => {toggleVisibility("COVID-19")},
                    )
                  ]),
              Visibility(
                visible: _visible["COVID-19"],
                child: Container(
                  height: _itemCount == 0 ? 50 : 350,
                  child: _itemCount == 0
                      ? Text("Loading...")
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.black54,
                                  ),
                                  ),
                              ),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    subtitle: Text(
                                      jsonResponse['COVID-19'][index],
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFF2265B3), fontSize: 18.0),
                                    ),
                                    onTap: () => {
                                      print(
                                          "Clicked on ${jsonResponse['COVID-19'][index]}"),
                                      _launchURL(jsonResponse['COVID-19'][index]
                                          .toString())
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: jsonResponse['COVID-19'].length,
                        ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Degree",
                          style: TextStyle(fontSize: 24.0),
                        )),
                    IconButton(
                      icon: Icon(_visible["DEGREE"] == false
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                      onPressed: () => {toggleVisibility("DEGREE")},
                    )
                  ]),
              Visibility(
                visible: _visible["DEGREE"],
                child: Container(
                  height: _itemCount == 0 ? 50 : 350,
                  child: _itemCount == 0
                      ? Text("Loading...")
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.black54,
                                  ))),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    //title: Text("DEGREE", style: TextStyle(fontSize: 24.0),),
                                    subtitle: Text(
                                      jsonResponse['DEGREE'][index],
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFF2265B3), fontSize: 18.0),
                                    ),
                                    onTap: () => {
                                      print(
                                          "Clicked on ${jsonResponse['DEGREE'][index]}"),
                                      _launchURL(jsonResponse['DEGREE'][index]
                                          .toString())
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: jsonResponse['DEGREE'].length,
                        ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Exam Section",
                          style: TextStyle(fontSize: 24.0),
                        )),
                    IconButton(
                      icon: Icon(_visible["EXAM_SECTION"] == false
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                      onPressed: () => {toggleVisibility("EXAM_SECTION")},
                    )
                  ]),
              AnnouncementsTile(),
              SizedBox(
                height: 20.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Notices",
                          style: TextStyle(fontSize: 24.0),
                        )),
                    IconButton(
                      icon: Icon(_visible["NOTICE"] == false
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                      onPressed: () => {toggleVisibility("NOTICE")},
                    )
                  ]),
              Visibility(
                visible: _visible["NOTICE"],
                child: Container(
                  height: _itemCount == 0 ? 50 : 350,
                  child: _itemCount == 0
                      ? Text("Loading...")
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.black54,
                                  ))),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    //title: Text("NOTICE", style: TextStyle(fontSize: 24.0),),
                                    subtitle: Text(
                                      jsonResponse['Notice'][index],
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFF2265B3), fontSize: 18.0),
                                    ),
                                    onTap: () => {
                                      print(
                                          "Clicked on ${jsonResponse['Notice'][index]}"),
                                      _launchURL(jsonResponse['Notice'][index]
                                          .toString())
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: jsonResponse['Notice'].length,
                        ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),

              ///Component changed to Miscellaneous
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Miscellaneous",
                          style: TextStyle(fontSize: 24.0),
                        )),
                    IconButton(
                      icon: Icon(_visible["COMPONENT"] == false
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up),
                      onPressed: () => {toggleVisibility("COMPONENT")},
                    )
                  ],
              ),
              Visibility(
                visible: _visible["COMPONENT"],
                child: Container(
                  height: _itemCount == 0 ? 50 : 350,
                  child: _itemCount == 0
                      ? Text("Loading...")
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    subtitle: Text(
                                      jsonResponse['component'][index],
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFF2265B3), fontSize: 18.0),
                                    ),
                                    onTap: () => {
                                      print("Clicked on ${jsonResponse['component'][index]}"),
                                      _launchURL(jsonResponse['component'][index].toString())
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: jsonResponse['component'].length,
                        ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Visibility AnnouncementsTile() {
    return Visibility(
      visible: _visible["EXAM_SECTION"],
      child: Container(
        height: _itemCount == 0 ? 50 : 350,
        child: _itemCount == 0
            ? Text("Loading...")
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          subtitle: Text(
                            jsonResponse['Exam_Section'][index],
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF2265B3), fontSize: 18.0),
                          ),
                          onTap: () => {
                            print(
                                "Clicked on ${jsonResponse['Exam_Section'][index]}"),
                            _launchURL(
                                jsonResponse['Exam_Section'][index].toString())
                          },
                        ),
                      ],
                    ),
                  );
                },
                itemCount: jsonResponse['Exam_Section'].length,
              ),
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
