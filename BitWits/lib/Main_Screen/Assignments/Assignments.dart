import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'add_assignment.dart';
import 'package:url_launcher/url_launcher.dart';

class Assignments extends StatefulWidget {
  @override
  _assignmentsState createState() => _assignmentsState();
}

// ignore: camel_case_types
class _assignmentsState extends State<Assignments> {
  DateTime _newValue = DateTime.now();
  bool check = false, delSpinner = false;
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2025));
    if (picked != null) setState(() => _newValue = picked);
  }

  Future<void> _updateValue(
      String code, String title, String roll, bool value) async {
    await Firestore.instance
        .collection('Classrooms/$code/Assignments')
        .document(title)
        .setData({
      'Completions': {roll: value}
    }, merge: true);
  }

  Widget _deleteDialog(String code, String title) {
    return StatefulBuilder(
      builder: (context, setState) => ModalProgressHUD(
        inAsyncCall: delSpinner,
        child: AlertDialog(
          title: Text('Delete $title ?'),
          actions: [
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('NO')),
            FlatButton(
                onPressed: () async {
                  setState(() => delSpinner = true);
                  try {
                    await Firestore.instance
                        .collection('Classrooms/$code/Assignments')
                        .document(title)
                        .delete();
                    await Firestore.instance
                        .collection('Classrooms/$code/Assignment Status')
                        .document(title)
                        .delete();
                    setState(() => delSpinner = false);
                    Navigator.pop(context);
                  } catch (e) {
                    setState(() => delSpinner = false);
                    //TODO: display error
                    Navigator.pop(context);
                  }
                },
                child: Text('YES')),
          ],
        ),
      ),
    );
  }

  _showAssignmentAction(String value, String code, String title) async {
    switch (value) {
      case 'Edit':
        //add date picker
        await _selectDate();
        await Firestore.instance
            .collection('Classrooms/$code/Assignments')
            .document(title)
            .updateData({'Deadline': _dateFormat.format(_newValue)});
        //TODO: notify users
        break;
      case 'Delete':
        showDialog(
            context: context, builder: (context) => _deleteDialog(code, title));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var mobile = MediaQuery.of(context);
    return Consumer<Data>(
      builder: (context, data, child) {
        // _getCompletionMap(data.currentClassCode, data.rollNumber);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                //CHECK:@azeez-72
                showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "Assignments",
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2265B3)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "Having trouble remembering pending assignments? Not any more!!",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "Click on the name of assignment to read description and download PDF.",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          );
        });
              },
            ),
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
              if (data.isCr)
                IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => AddAssignment(),
                          isScrollControlled: true);
                    }),
              // IconButton(icon: Icon(Icons.refresh), onPressed: () async => await _getCompletionMap(data.currentClassCode, data.rollNumber))
            ],
          ),
          body: Scrollbar(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection(
                        'Classrooms/${data.currentClassCode}/Assignments')
                    .orderBy('Deadline')
                    .snapshots(),
                builder: (context, dataSnapShot) {
                  if (dataSnapShot.connectionState == ConnectionState.waiting)
                    return Center(
                        child: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.grey[600]),
                    ));
                  final studentDocs = dataSnapShot.data.documents;
                  return ListView.separated(
                      // padding: const EdgeInsets.all(8),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(thickness: 0.5, color: Colors.grey[400]),
                      itemBuilder: (context, index) {
                        Color textColor = Colors.black;
                        var textdecoration = TextDecoration.none;
                        if (studentDocs[index]['Completions']
                                    [data.rollNumber] ==
                                null
                            ? false
                            : studentDocs[index]['Completions']
                                    [data.rollNumber] ==
                                true) {
                          textColor = Colors.blueGrey[300];
                          textdecoration = TextDecoration.lineThrough;
                        }
                        return ListTile(
                          onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: mobile.size.height * 0.75,
                                  width: double.infinity,
                                  child: Scrollbar(
                                    child: ListView(children: [
                                      ListTile(
                                        trailing: studentDocs[index]
                                                ['Completions'][data.rollNumber]
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 28,
                                              )
                                            : Icon(
                                                Icons.error_outline,
                                                color: DateTime.parse(
                                                                studentDocs[
                                                                        index][
                                                                    'Deadline'])
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays <
                                                        2
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 28,
                                              ),
                                        title: Text(
                                          'Description',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                      ),
                                      if (studentDocs[index]['G-drive link'] !=
                                          '')
                                        SizedBox(height: 16),
                                      if (studentDocs[index]['G-drive link'] !=
                                          '')
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 16),
                                          child: ButtonTheme(
                                            minWidth: 100,
                                            height: 40,
                                            child: OutlineButton(
                                                borderSide: BorderSide(
                                                    color: mainColor),
                                                //studentDocs[index]['G-drive link'] has the link
                                                child: Text(
                                                  'Open File',
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 18),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                onPressed: () => launch(
                                                    studentDocs[index]
                                                        ['G-drive link'])),
                                          ),
                                        ),
                                      Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Container(
                                            child: Text(
                                              studentDocs[index]['Description'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  wordSpacing: 1,
                                                  height: 1.2),
                                            ),
                                          ))
                                    ]),
                                  ),
                                );
                              }),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: data.isCr
                                        ? mobile.size.width * 0.5665
                                        : mobile.size.width * 2 / 3,
                                    maxWidth: data.isCr
                                        ? mobile.size.width * 0.5665
                                        : mobile.size.width * 2 / 3),
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          "${index + 1}. ${studentDocs[index]['Title']}", //to change
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Thesis",
                                            color: textColor,
                                            decoration: textdecoration,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Checkbox(
                                      value: studentDocs[index]['Completions'][data.rollNumber] == null ? false : studentDocs[index]['Completions'][data.rollNumber],
                                      activeColor: Colors.green[300],
                                      onChanged: (value) async => await _updateValue(data.currentClassCode, studentDocs[index]['Title'], data.rollNumber,value),
                                    ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Due:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          DateTime.parse(studentDocs[index]
                                                          ['Deadline'])
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays <
                                                  0
                                              ? studentDocs[index]
                                                          ['Completions']
                                                      [data.rollNumber]
                                                  ? '${studentDocs[index]['Deadline'].toString().split('-').reversed.join('-')}\nExceeded'
                                                  : studentDocs[index]
                                                          ['Deadline']
                                                      .toString()
                                                      .split('-')
                                                      .reversed
                                                      .join('-')
                                              : studentDocs[index]['Deadline']
                                                  .toString()
                                                  .split('-')
                                                  .reversed
                                                  .join('-'),
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: DateTime.parse(
                                                            studentDocs[index]
                                                                ['Deadline'])
                                                        .difference(
                                                            DateTime.now())
                                                        .inDays <
                                                    2
                                                ? !studentDocs[index]
                                                            ['Completions']
                                                        [data.rollNumber]
                                                    ? FontWeight.bold
                                                    : FontWeight.bold
                                                : FontWeight.w500,
                                            color: DateTime.parse(
                                                            studentDocs[index]
                                                                ['Deadline'])
                                                        .difference(
                                                            DateTime.now())
                                                        .inDays <
                                                    2
                                                ? !studentDocs[index]
                                                            ['Completions']
                                                        [data.rollNumber]
                                                    ? Colors.red
                                                    : Colors.black
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (data.isCr)
                                    Container(
                                          margin: EdgeInsets.only(left:17.0),
                                          child: PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey[700],
                                          ),
                                          onSelected: (String val) =>
                                              _showAssignmentAction(
                                                  val,
                                                  data.currentClassCode,
                                                  studentDocs[index]['Title']),
                                          itemBuilder: (context) =>
                                              <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  value: 'Edit',
                                                  child: Text(
                                                      'Change submission date'),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'Delete',
                                                  child:
                                                      Text('Delete assignment'),
                                                )
                                              ]),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: studentDocs.length);
                },
              ),
            ),
          ),
          // ) : Center(child: Container(height: 50,width: 250,child: Text( data.isCr? 'No assignments!...Click on + to add an assignment' : 'No assignments yet',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[500],fontSize: 18,),))),
        );
      },
    );
  }
}
