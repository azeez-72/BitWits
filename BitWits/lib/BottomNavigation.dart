import 'package:bitwitsapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Home_Screen/Announcements.dart';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Home_Screen/Students_list.dart';

int _selectedIndex = 0;

class BottomNavigation extends StatefulWidget {
  static String id = "stack";

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: bottomnavbar(onTap: 
        (int index) => setState(() => _selectedIndex = index)),
      body: IndexedStack(
        children: <Widget>[
          Announcements(),
          Assignments(),
          Students_list(),
        ],
        index: _selectedIndex,
      ),
    );
  }
}

class bottomnavbar extends StatelessWidget {
  final Function onTap;

  bottomnavbar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: mainColor,
      currentIndex: _selectedIndex,
      onTap: onTap,
      backgroundColor: Color(0xFFF8F8F8),
      iconSize: 32,
      selectedFontSize: 13,
      unselectedFontSize: 11,
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
              Icons.people,
              color: _selectedIndex == 2 ? mainColor : Color(0xFF828282),
            ),
            title: Text("Class")),
      ],
    );
  }
}