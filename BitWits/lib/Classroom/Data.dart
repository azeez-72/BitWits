import 'package:flutter/material.dart';

class Data extends ChangeNotifier{
  String currentClassCode,currentEmail;

  void saveEmailAndCode(String email,String code){
    currentClassCode = code;
    currentEmail = email;
    notifyListeners();
  }
}