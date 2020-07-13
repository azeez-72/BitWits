import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "New Announcement",
              style: TextStyle(
                color: mainColor,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  "Okay",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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
      onMessage: (Map<String, dynamic> title) async {
        print('onMessage: $title');
        _setMessage(title);
        createAlertDialog(context);
      },
      onLaunch: (Map<String, dynamic> title) async {
        print('onLaunch: $title');
        _setMessage(title);
      },
      onResume: (Map<String, dynamic> title) async {
        print('onResume: $title');
        _setMessage(title);
      },
    );
  }

  _setMessage(Map<String, dynamic> title) {
    final notification = title['notification'];
    final data = title['data'];
    final String heading = notification['heading'];
    final String body = notification['body'];
    final String mMessage = data['title'];
    print("Heading: $heading, body: $body, title: $mMessage");
    setState(() {
      Message m = Message(heading, body, mMessage);
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

  String refineUrl(String u) {
    var _newString = u.replaceAll('%', ' ');
    _newString = _newString.replaceAll('https://www.vjti.ac.in/images/', '');
    _newString = _newString.replaceAll('/', ' : ');
    List<int> i = [0, 1, 2, 3, 4 , 5, 6, 7 ,8 ,9];
    for (var a in i) {
      _newString = _newString.replaceAll(a.toString(), '');
    }
    _newString = _newString.replaceAll('.pdf', '');
    _newString = _newString.replaceAll('_', ' ');
    return _newString;
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
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
                    "Click on the links provided under each respective sections to view corresponding PDF.",
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
  // Future<void> _saveHistory(String url,String email) async {
  //   try{await Firestore.instance.collection('Announcement taps').document(url).setData({email: DateTime.now()},merge: true);}
  //   catch(e){print(e);}
  // }

  final bool _labelVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _settingModalBottomSheet(context),
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
        ),
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  AnnouncementSection(
                    title: 'COVID-19',
                    visible: _visible["COVID-19"],
                    onTap: () => {toggleVisibility("COVID-19")},
                  ),
                  Visibility(
                    visible: _visible["COVID-19"],
                    child: Container(
                      height: _itemCount == 0 ? 50 : 350,
                      child: _itemCount == 0
                          ? Text("Loading...")
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return AnnouncementList(
                                  labelVisible: index == 0 ? true : false,
                                  subtitle: refineUrl(jsonResponse['COVID-19'][index]),
                                  onTap: () async => {
                                    print(
                                        "Clicked on ${jsonResponse['COVID-19'][index]}"),
                                    // await _saveHistory(jsonResponse['Notice'][index], data.currentEmail),
                                    _launchURL(jsonResponse['COVID-19'][index]
                                        .toString())
                                  },
                                );
                              },
                              itemCount: jsonResponse['COVID-19'].length,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  AnnouncementSection(
                    title: 'DEGREE',
                    visible: _visible['DEGREE'],
                    onTap: () => {toggleVisibility('DEGREE')},
                  ),
                  Visibility(
                    visible: _visible["DEGREE"],
                    child: Container(
                      height: _itemCount == 0 ? 50 : 350,
                      child: _itemCount == 0
                          ? Text("Loading...")
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return AnnouncementList(
                                  labelVisible: index == 0 ? true : false,
                                  subtitle: refineUrl(jsonResponse['DEGREE'][index]),
                                  onTap: () async => {
                                    print(
                                        "Clicked on ${jsonResponse['DEGREE'][index]}"),
                                    // await _saveHistory(jsonResponse['Notice'][index], data.currentEmail),
                                    _launchURL(jsonResponse['DEGREE'][index]
                                        .toString())
                                  },
                                );
                              },
                              itemCount: jsonResponse['DEGREE'].length,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  AnnouncementSection(
                    title: 'Exam Section',
                    visible: _visible['EXAM_SECTION'],
                    onTap: () => {toggleVisibility('EXAM_SECTION')},
                  ),
                  Visibility(
                    visible: _visible["EXAM_SECTION"],
                    child: Container(
                      height: _itemCount == 0 ? 50 : 350,
                      child: _itemCount == 0
                          ? Text("Loading...")
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return AnnouncementList(
                                  labelVisible: index == 0 ? true : false,
                                  subtitle: refineUrl(jsonResponse['Exam_Section'][index]),
                                  onTap: () async => {
                                    print(
                                        "Clicked on ${jsonResponse['Exam_Section'][index]}"),
                                    // await _saveHistory(jsonResponse['Notice'][index], data.currentEmail),
                                    _launchURL(jsonResponse['Exam_Section']
                                            [index]
                                        .toString())
                                  },
                                );
                              },
                              itemCount: jsonResponse['Exam_Section'].length,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  AnnouncementSection(
                    title: 'Notices',
                    visible: _visible['NOTICE'],
                    onTap: () => {toggleVisibility('NOTICE')},
                  ),
                  Visibility(
                    visible: _visible["NOTICE"],
                    child: Container(
                      height: _itemCount == 0 ? 50 : 350,
                      child: _itemCount == 0
                          ? Text("Loading...")
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return AnnouncementList(
                                  labelVisible: index == 0 ? true : false,
                                  subtitle: refineUrl(jsonResponse['Notice'][index]),
                                  onTap: () async => {
                                    print(
                                        "Clicked on ${jsonResponse['Notice'][index]}"),
                                    // await _saveHistory(jsonResponse['Notice'][index], data.currentEmail),
                                    _launchURL(jsonResponse['Notice'][index]
                                        .toString())
                                  },
                                );
                              },
                              itemCount: jsonResponse['Notice'].length,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //Component changed to Miscellaneous
                  AnnouncementSection(
                    title: 'Miscellaneous',
                    visible: _visible['COMPONENT'],
                    onTap: () => {toggleVisibility('COMPONENT')},
                  ),
                  Visibility(
                    visible: _visible["COMPONENT"],
                    child: Container(
                      height: _itemCount == 0 ? 50 : 350,
                      child: _itemCount == 0
                          ? Text("Loading...")
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return AnnouncementList(
                                  labelVisible: index == 0 ? true : false,
                                  subtitle: refineUrl(jsonResponse['component'][index]),
                                  onTap: () async => {
                                    print(
                                        "Clicked on ${jsonResponse['component'][index]}"),
                                    // await _saveHistory(jsonResponse['Notice'][index], data.currentEmail),
                                    _launchURL(jsonResponse['component'][index]
                                        .toString())
                                  },
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
        ),
      ),
    );
  }
}

class AnnouncementList extends StatelessWidget {
  final Function onTap;
  final String subtitle;
  final bool labelVisible;

  AnnouncementList({this.subtitle, this.onTap, this.labelVisible});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.black54,
          ))),
      padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            trailing: labelVisible
                ? Container(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          )
                        ],
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Latest",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ))
                : null,
            subtitle: Text(
              subtitle,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xFF2265B3),
                  fontSize: 18.0),
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class AnnouncementSection extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool visible;

  AnnouncementSection({this.title, this.visible, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 24.0),
      ),
      trailing: IconButton(
        icon: Icon(
          visible == false ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          color: Colors.black,
        ),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }
}

class Message {
  String heading;
  String body;
  String title;
  Message(heading, body, title) {
    this.heading = heading;
    this.body = body;
    this.title = title;
  }
}
//body: $body,
