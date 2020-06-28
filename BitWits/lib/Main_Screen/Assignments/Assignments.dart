import 'dart:collection';

import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:provider/provider.dart';
import 'add_assignment.dart';

class Assignments extends StatefulWidget {
  static Map<String,bool> completionMap = HashMap();
  
  @override
  _assignmentsState createState() => _assignmentsState();
}

// ignore: camel_case_types
class _assignmentsState extends State<Assignments> {
  int n = 2;

  Future<void> _updateValue(String code,String title,String roll,bool value) async {
    await Firestore.instance
          .collection('Classrooms/$code/Assignment Status')
          .document(title).updateData({roll : value});

    setState(() => Assignments.completionMap[title] = value);
  }

  @override
  Widget build(BuildContext context) {
    var mobile = MediaQuery.of(context);
    return Consumer<Data>(
      builder: (context,data,child){
        // _getCompletionMap(data.currentClassCode, data.rollNumber);
        return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.info_outline),onPressed: (){},),
          title: Text(
            'Assignments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: mainColor,
          actions: [
            if(data.isCr)
            IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) => AddAssignment(),isScrollControlled: true);
              }
            ),
            // IconButton(icon: Icon(Icons.refresh), onPressed: () async => await _getCompletionMap(data.currentClassCode, data.rollNumber))
          ],
        ),
        body: Assignments.completionMap == null ? LoadingScreen() : Scrollbar(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: StreamBuilder(
              stream: Firestore.instance.collection('Classrooms/${data.currentClassCode}/Assignments').orderBy('Deadline').snapshots(),
              builder: (context,dataSnapShot) {
                if(dataSnapShot.connectionState == ConnectionState.waiting) return Center(child: Text("Loading...", style: TextStyle(color: Colors.grey[600]),));
                final studentDocs = dataSnapShot.data.documents;
                return ListView.separated(
                // padding: const EdgeInsets.all(8),
                  separatorBuilder: (BuildContext context,int index) => Divider(thickness: 0.5,color: Colors.grey[400]),
                  itemBuilder: (context,index) {
                    // _getCompletionMap(data.currentClassCode,data.rollNumber);
                    Color textColor = Colors.black;
                    var textdecoration = TextDecoration.none;
                    if (Assignments.completionMap[studentDocs[index]['Title']] == null ? false : Assignments.completionMap[studentDocs[index]['Title']] == true) {
                      textColor = Colors.blueGrey[300];
                      textdecoration = TextDecoration.lineThrough;
                    }
                    return ListTile(
                      title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ConstrainedBox(
                              constraints: BoxConstraints(minWidth: mobile.size.width*2/3),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "${index+1}. ${studentDocs[index]['Title']}", //to change
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "Thesis",
                                          color: textColor,
                                          decoration: textdecoration,
                                        ),
                                      ),
                                      CircularCheckBox(
                                        value: Assignments.completionMap[studentDocs[index]['Title']] == null ? false : Assignments.completionMap[studentDocs[index]['Title']],
                                        activeColor: Colors.green[300],
                                        onChanged: (value) async => await _updateValue(data.currentClassCode, studentDocs[index]['Title'], data.rollNumber,value),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Due:',style: TextStyle(fontWeight: FontWeight.normal),),
                                    SizedBox(height: 5,),
                                    Text(
                                      //TODO: CHANGE THE FONTSIZE
                                      studentDocs[index]['Deadline'].toString().split('-').reversed.join('-'),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: DateTime.parse(studentDocs[index]['Deadline'])
                                                    .difference(DateTime.now())
                                                    .inDays <
                                                2 ? FontWeight.bold : FontWeight.normal,
                                        color: DateTime.parse(studentDocs[index]['Deadline'])
                                                    .difference(DateTime.now())
                                                    .inDays <
                                                2
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  },itemCount: studentDocs.length
                );
              },
            ),
          ),
        ),
      );
      },
    );
  }
}
