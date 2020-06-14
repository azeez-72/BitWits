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

  static Map getBranch() {
    Map<String, String> sform = HashMap();

    sform["Computer"] = "cs";
    sform["IT"] = "it";
    sform["EXTC"] = "tc";
    sform["Electronics"] = "es";
    sform["Electrical"] = "el";
    sform["Mechanical"] = "me";
    sform["Civil"] = "cv";
    sform["Production"] = "pr";
    sform["Textile"] = "tx";

    return sform;
  }
}
