import 'package:bitwitsapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Home_Screen/Announcements.dart';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Home_Screen/Students_list.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  List<Widget> tabs = [
    Announcements(),
    Assignments(),
    Students_list()
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: mainColor,
      currentIndex: _currentIndex,
      onTap:(int index){
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: Color(0xFFF8F8F8),
      iconSize: 32,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.announcement,color: Color(0xFF828282),),
          title: Text("Announcements")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment,color: Color(0xFF828282),),
          title: Text("Assignments")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people,color: Color(0xFF828282),),
          title: Text("Class")
        ),
      ],
    );
  }
}