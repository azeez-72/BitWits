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
  int _selectedIndex = 0;
  List<Widget> _tabs = [Announcements(), Assignments(), Students_list()];
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
//    Navigator.push(context, MaterialPageRoute(builder: (context){
//      return _tabs.elementAt(_selectedIndex);
//    },),);
  // app crashed because of invalid route name
//    switch(_selectedIndex){
//      case(0):
//        Navigator.pushNamed(context, Announcements.id);
//        break;
//      case(1):
//        Navigator.pushNamed(context, Assignments.id);
//        break;
//      case(2):
//        Navigator.pushNamed(context, Students_list.id);
//    }
  // app crashed because of invalid push route

    return BottomNavigationBar(
      selectedItemColor: mainColor,
      currentIndex: _selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Color(0xFFF8F8F8),
      iconSize: 32,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.announcement,
              color: Color(0xFF828282),
            ),
            title: Text("Announcements")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              color: Color(0xFF828282),
            ),
            title: Text("Assignments")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: Color(0xFF828282),
            ),
            title: Text("Class")),
      ],
    );
  }
}
