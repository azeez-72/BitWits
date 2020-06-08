import 'package:bitwitsapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Home_Screen/Announcements.dart';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Home_Screen/Students_list.dart';

int _selectedIndex = 0;

class BottomNavigation extends StatefulWidget {

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      selectedItemColor: mainColor,
      currentIndex: _selectedIndex,
      onTap: (int index){
        setState(() {
          _selectedIndex = index;
          switch(_selectedIndex){
            case 0:
              Navigator.pushNamed(context, Announcements.id);
              break;
            case 1:
              Navigator.pushNamed(context, Assignments.id);
              break;
            case 2:
              Navigator.pushNamed(context, Students_list.id);
              break;
          }
        });
      },
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
