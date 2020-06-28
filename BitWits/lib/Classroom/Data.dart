import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Data extends ChangeNotifier{
  String currentClassCode,currentEmail,rollNumber,name,branch,uid;
  bool isCr;
  Map<String,bool> completionMap = HashMap<String,bool>();

  void saveEmailAndCode(String name,String email,String code,String roll,String uid){
    currentClassCode = code;
    currentEmail = email;
    rollNumber = roll;
    this.uid = uid;
    this.name = name;
    notifyListeners();
  }

  // Future<void> getCompletionMap(String code,String roll) async {
  //   await Firestore.instance.collection('Classrooms/$code/Assignments').getDocuments()
  //   .then((snapshot){
  //     snapshot.documents.forEach((doc) async { 
  //       await Firestore.instance
  //         .collection('Classrooms/$code/Assignment Status')
  //         .document(doc.documentID)
  //         .get().then((DocumentSnapshot docSnap){
  //           completionMap[doc.documentID] = docSnap[roll];
  //           notifyListeners();
  //       }); 
  //     });
  //   });
  // }

  // void getCompletionData() async {
  //   await getCompletionMap(currentClassCode, rollNumber);
  //   notifyListeners();
  // }

  // void updateData(String title,bool value){
  //   completionMap[title] = value;
  //   notifyListeners();
  // }

  void addBranch(String branch){
    this.branch = branch;
    notifyListeners();
  }

  void crStatus(bool isCr){
    this.isCr = isCr;
    notifyListeners();
  }

  void updateName(String name){
    this.name = name;
    notifyListeners();
  }

  void updateRoll(String roll){
    rollNumber = roll;
    notifyListeners();
  }
}