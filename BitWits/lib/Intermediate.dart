import 'package:bitwitsapp/Classroom/unjoined.dart';
import 'package:bitwitsapp/Main_Screen/Dashboard_screen.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Intermediate extends StatefulWidget {
  static String id = 'intermediate';

  @override
  _IntermediateState createState() => _IntermediateState();
}

class _IntermediateState extends State<Intermediate> {
  FirebaseUser currentUser;
  final _auth = FirebaseAuth.instance;
  String _email;

  Future<void> registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    setState(() {
      currentUser = regUser;
      _email = currentUser.email;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2));
    registeredCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Status').document(_email).snapshots(),
      builder: (context , snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) return LoadingScreen();
        final docs = snapshot.data;
        if(docs['Current class code'] == 'NA') return Unjoined();
        return BottomNavigation();
      }
    );
  }
}