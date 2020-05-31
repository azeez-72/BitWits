import 'dart:collection';

class Info {

  static var years = [
      "1",
      "2",
      "3",
      "4",
    ];

  static var batches = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
    ];

    static var branches = [
    "Computer",
    "IT",
    "EXTC",
    "Electronics",
    "Electrical",
    "Mechanical",
    "Civil",
    "Production",
    "Textile",
  ];

  static Map<String,String> sform = HashMap();
  
  static void assign(){

    sform[branches[0]] = "cs";
    sform[branches[1]] = "it";
    sform[branches[2]] = "tc";
    sform[branches[3]] = "es";
    sform[branches[4]] = "el";
    sform[branches[5]] = "me";
    sform[branches[6]] = "cv";
    sform[branches[7]] = "pr";
    sform[branches[8]] = "tx";
  }

}