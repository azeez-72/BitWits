import 'package:bitwitsapp/Main_Screen/menu_options/menu_list.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'Announcements/Announcements.dart';
import 'Assignments/Assignments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

int _selectedIndex = 1;

class Dashboard extends StatefulWidget {
  static String id = "stack";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  
  Future<void> registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
    await Firestore.instance
        .collection("Status")
        .document(currentUser.email)
        .get()
        .then((DocumentSnapshot snapshot) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(
          currentUser.email + "@", snapshot.data["Current class code"]);
      print(preferences.getString(currentUser.email+"@"));
    });
  }

  @override
  void initState() {
    super.initState();

    registeredCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: bottomnavbar(
          onTap: (int index) => setState(() => _selectedIndex = index)),
        body: IndexedStack(
          children: <Widget>[
            Announcements(),
            Assignments(),
            MenuList(),
          ],
          index: _selectedIndex,
        ),
      ),
    );
  }
}

class bottomnavbar extends StatelessWidget {
  final Function onTap;

  bottomnavbar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavigationBar(
        selectedItemColor: mainColor,
        currentIndex: _selectedIndex,
        onTap: onTap,
        backgroundColor: Color(0xFFF8F8F8),
        iconSize: 32,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.announcement,
                color: _selectedIndex == 0 ? mainColor : Color(0xFF828282),
              ),
              title: Text("Announcements")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment,
                color: _selectedIndex == 1 ? mainColor : Color(0xFF828282),
              ),
              title: Text("Assignments")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz,
                color: _selectedIndex == 2 ? mainColor : Color(0xFF828282),
              ),
              title: Text("More")),
        ],
      ),
    );
  }
}
