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

  //assignments content start
  // final List<String> name = <String>['Launching Missile'];
  // final List<String> description = <String>[
  //   'You decide the location to destroy'
  // ];
  final List<bool> isDone = <bool>[false];
  final List<DateTime> _datesOfSubmission = <DateTime>[DateTime.now()];
  //end

  // Future<void> update(int index,bool value,String code){
  //   Firestore.instance.collection('Classrooms/$code/Assignments').
  // }

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
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 8,right: 8),
          child: StreamBuilder(
            stream: Firestore.instance.collection('Classrooms/${data.currentClassCode}/Assignments').snapshots(),
            builder: (context,dataSnapShot){
              if(dataSnapShot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
              final studentDocs = dataSnapShot.data.documents;
              print(studentDocs.length.toString());
              return ListView.separated(
              // padding: const EdgeInsets.all(8),
                separatorBuilder: (BuildContext context,int index) => Divider(thickness: 0.5,color: Colors.grey[400]),
                itemBuilder: (BuildContext context, int index) {
                  Color textColor = Colors.black;
                  var textdecoration = TextDecoration.none;
                  if (isDone[index] == true) {
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
                                      activeColor: Colors.green[300],
                                      value: isDone[index],
                                      // value: studentDocs[index]
                                      //   .collection('Completion Status')
                                      //   .document(data.rollNumber)
                                      //   .get()
                                      //   .then((DocumentSnapshot snapshot) => snapshot.data['isDone']),
                                      onChanged: (value) {
                                        setState(() {
                                          isDone[index] = value;
                                          // Firestore.instance.collection('Completion Status')
                                          // .document(data.rollNumber)
                                          // .updateData({'isDone': value});
                                        });
                                      },
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
                                      color: _datesOfSubmission[index]
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
                        // Divider(thickness: 0.5,color: Colors.grey[400],)
                      ],
                    ),
                  ),
                  // onTap: () => {showBottomSheet(context, index)},
                );
              },itemCount: studentDocs.length
              );
            },
          ),
        ),
      );
      },
    );
  }
}
