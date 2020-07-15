import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';


class Syllabus extends StatefulWidget {
  static final String id = "syllabus";

  @override
  _SyllabusState createState() => _SyllabusState();
}

class _SyllabusState extends State<Syllabus> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map <String, List<String>> map1 = {
      "Maths": ["chp1", "chp2"],
      "Chem" : ["chp11", "chp12"],
      "Phy" : ["chp91", "chp5"],
      "Comps" : ["chp51", "chp54"],
    };

    print(map1);

   return Scaffold(
     appBar: AppBar(
            leading: 
              IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ 
                Navigator.pop(context);
              }),
            title: Text('Syllabus'),
            backgroundColor: mainColor,
    ),
    body: SafeArea(
      child : DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Subject',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Topics',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
          ],
        ),
      ],
    )
    ),
   ); 
  }
}