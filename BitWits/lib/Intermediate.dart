import 'package:bitwitsapp/Classroom/Choose.dart';
import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:bitwitsapp/Classroom/unjoined.dart';
import 'package:bitwitsapp/Main_Screen/Dashboard_screen.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Intermediate extends StatefulWidget {
  static String id = 'intermediate';

  @override
  _IntermediateState createState() => _IntermediateState();
}

class _IntermediateState extends State<Intermediate> {
  final _auth = FirebaseAuth.instance;
  String _email,_uuid;

  Future<void> registeredCurrentUser() async =>
     await _auth.currentUser()
      .then((value) {
        setState(() {
          _email = value.email;
          _uuid = value.uid;
        });
      });

  @override
  void initState() {
    super.initState();

    registeredCurrentUser();
  }

  @override
  Widget build(BuildContext context) {

    return _email != null && _uuid != null ? StreamBuilder(
      stream: Firestore.instance.collection('Status').document(_email).snapshots(),
      builder: (context , snapshot){
        
        if(snapshot.connectionState == ConnectionState.waiting) return LoadingScreen();
        final docs = snapshot.data;
        if(snapshot.connectionState == ConnectionState.active) {

          if(docs['${docs['Current class code']} CR'] == true) Provider.of<Data>(context).crStatus(true);
          else Provider.of<Data>(context).crStatus(false);

          if(docs['Current class code'] == 'NA') return Unjoined();
          else if(docs['Current class code'] == 'New') return Navigate();
          else {
            Provider.of<Data>(context).saveEmailAndCode(docs['Name'],_email, docs['Current class code'],docs['roll number'],_uuid);
            if(docs['Current class code'].toString().substring(5,6) == '1') Provider.of<Data>(context).addBranch(docs['Branch']);
          }
        
        } 
        return Dashboard();
      }
    ) : LoadingScreen();
  }
}