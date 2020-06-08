import 'package:flutter/material.dart';
import 'package:bitwitsapp/constants.dart';

class Announcements extends StatefulWidget {
  static final String id  = 'Announcements';
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Assignments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: mainColor,
        actions: <Widget>[],
      ),
    );
  }
}