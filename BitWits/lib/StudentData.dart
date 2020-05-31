import 'dart:collection';
import 'package:flutter/cupertino.dart';

class StudentData extends ChangeNotifier {

  Map<String,Map<String,String>> data = HashMap();

  void addData(String email,String field,String value){
    data[email][field] = value;
    notifyListeners();
  }

}