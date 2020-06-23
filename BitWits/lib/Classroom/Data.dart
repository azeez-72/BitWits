import 'package:flutter/material.dart';

class Data extends ChangeNotifier{
  String currentClassCode,currentEmail,rollNumber;

  void saveEmailAndCode(String email,String code,String roll){
    currentClassCode = code;
    currentEmail = email;
    rollNumber = roll;
    notifyListeners();
  }
}