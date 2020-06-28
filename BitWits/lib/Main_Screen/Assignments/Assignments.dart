import 'dart:collection';

import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:provider/provider.dart';
import 'add_assignment.dart';

class Assignments extends StatefulWidget {
  @override
  _assignmentsState createState() => _assignmentsState();
}

// ignore: camel_case_types
class _assignmentsState extends State<Assignments> {

  Map<String,bool> _completionMap = HashMap<String,bool>();

  Future<void> _getCompletionMap(String code,String roll) async {
    await Firestore.instance.collection('Classrooms/$code/Assignments').getDocuments()
    .then((snapshot){
      snapshot.documents.forEach((doc) async { 
        await Firestore.instance
          .collection('Classrooms/$code/Assignment Status')
          .document(doc.documentID)
          .get().then((DocumentSnapshot docSnap){
            setState(() =>_completionMap[doc.documentID] =  docSnap[roll]);
        }); 
      });
    });
  }

  Future<void> _updateValue(String code,String title,String roll,bool value) async {
    await Firestore.instance
          .collection('Classrooms/$code/Assignment Status')
          .document(title).updateData({roll : value});

    setState(() => _completionMap[title] = value);
  }

  @override
  Widget build(BuildContext context) {
    var mobile = MediaQuery.of(context);
    return Consumer<Data>(
      builder: (context,data,child){
        return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
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
            IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) => AddAssignment(),isScrollControlled: true);
              }
            ),
            IconButton(icon: Icon(Icons.refresh), onPressed: () async => await _getCompletionMap(data.currentClassCode, data.rollNumber))
          ],
        ),
        body: Scrollbar(
          child: Padding(
            padding: EdgeInsets.only(top: 8,right: 8),
            child: StreamBuilder(
              stream: Firestore.instance.collection('Classrooms/${data.currentClassCode}/Assignments').snapshots(),
              builder: (context,dataSnapShot) {
                if(dataSnapShot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                final studentDocs = dataSnapShot.data.documents;
                return ListView.separated(
                // padding: const EdgeInsets.all(8),
                  separatorBuilder: (BuildContext context,int index) => Divider(thickness: 0.5,color: Colors.grey[400]),
                  itemBuilder: (context,index) {
                    // _getCompletionMap(data.currentClassCode,data.rollNumber);
                    print(studentDocs[index]['Title']+':'+_completionMap[studentDocs[index]['Title']].toString());
                    Color textColor = Colors.black;
                    var textdecoration = TextDecoration.none;
                    if (_completionMap[studentDocs[index]['Title']] == true) {
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
                                        value: _completionMap[studentDocs[index]['Title']],
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
                                    Text('Due:',style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Text(
                                      //TODO: CHANGE THE FONTSIZE
                                      studentDocs[index]['Deadline'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        // color: _datesOfSubmission[index]
                                        //             .difference(DateTime.now())
                                        //             .inDays <
                                        //         2
                                        //     ? Colors.red
                                        //     : Colors.black87,
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
