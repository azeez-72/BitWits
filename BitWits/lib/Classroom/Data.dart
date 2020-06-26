import 'package:flutter/material.dart';

class Data extends ChangeNotifier{
  String currentClassCode,currentEmail,rollNumber,name,branch,uid;
  bool isCr;

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
}