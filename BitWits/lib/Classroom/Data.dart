import 'dart:collection';
import 'package:flutter/material.dart';

class Data extends ChangeNotifier{
  String currentClassCode,currentEmail,rollNumber,name,branch,uid,yearAbb;
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

  String getYearAbbreviation(){
    switch (currentClassCode.substring(5,6)) {
      case '8':
        yearAbb = 'FY';
        break;
      case '2':
        yearAbb = 'SY';
        break;
      case '3':
        yearAbb = 'TY';
        break;
      case '4':
        yearAbb = 'Final';
        break;
      default:
        yearAbb = 'loading';
    }
    notifyListeners();
    return yearAbb;
  }

}