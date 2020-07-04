import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:bitwitsapp/Intermediate.dart';
import 'package:bitwitsapp/Utilities/info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:clipboard_manager/clipboard_manager.dart';

class Students_list extends StatefulWidget {
  static final String id = 'students_list';

  @override
  _Students_listState createState() => _Students_listState();
}

class _Students_listState extends State<Students_list> {
  String year, batch, code, branch;
  String data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _leaveClass(String email, String code) async {
    await Firestore.instance
        .collection('Status')
        .document(email)
        .updateData({'Current class code': 'NA'});
    await Firestore.instance
        .collection('History')
        .document(email)
        .setData({'class left on ${DateTime.now()}': code}, merge: true);
  }

  Future<void> _addAsCR(String email, String code, String crEmail) async {
    String uid;
    await Firestore.instance
        .collection('Status')
        .document(email)
        .setData({'$code CR': true}, merge: true);
    await Firestore.instance.collection('History').document(email).setData(
        {'made CR on ${DateTime.now()} by $crEmail': code},
        merge: true);
    await Firestore.instance.collection('History').document(crEmail).setData(
        {'assigned CR status on ${DateTime.now()} to $email': code},
        merge: true);
    await Firestore.instance
        .collection('Classrooms/$code/Students')
        .where('email', isEqualTo: email)
        .limit(1)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        uid = doc.documentID;
      });
    });
    await Firestore.instance
        .collection('Classrooms/$code/Students')
        .document(uid)
        .updateData({'CR': true});
  }

  Widget showAddDialog(
          String actionShow, String email, String code, String crEmail) =>
      AlertDialog(
        title: Text('Are you sure?'),
        content: Text(actionShow),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
          FlatButton(
              onPressed: () async {
                await _addAsCR(email, code, crEmail);
                Navigator.pop(context);
              },
              child: Text('YES'))
        ],
      );

  Widget showRemoveDialog(
          String actionShow, String email, String code, String crEmail) =>
      AlertDialog(
        title: Text('Are you sure?'),
        content: Text(actionShow),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
          FlatButton(
              onPressed: () async {
                await _addAsCR(email, code, crEmail);
                Navigator.pop(context);
              },
              child: Text('YES'))
        ],
      );

  Future<void> _selectAction(
      String value, String code, String crEmail, String name, String email) {
    switch (value) {
      case 'CR':
        showDialog(
            context: context,
            builder: (context) =>
                showAddDialog('Add $name as CR?', email, code, crEmail));
        break;
      // case 'Remove':
      //   showDialog(context: context,builder: (context) => showRemoveDialog('Remove $name from class?',email,code,crEmail));
      //   break;
      default:
        print('none');
    }
  }

  // Widget blockUnBlockDialog(String msg,String code,bool status) =>
  //   AlertDialog(
  //     title: Text('$msg class?'),
  //     actions: [
  //       FlatButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
  //       FlatButton(
  //         onPressed: () async => await Firestore.instance.collection('Classrooms').document(code).updateData({'block': status}),
  //         child: null
  //       )
  //     ],
  //   );

  Widget _alertShowCode(String code) => AlertDialog(
        title: Text(
          'Class code is:',
          style: TextStyle(color: mainColor),
        ),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('CLOSE'))
        ],
        content: Row(
          children: [
            Text(
              code,
              style: TextStyle(
                  color: mainColor, fontSize: 20, fontStyle: FontStyle.italic),
            ),
            SizedBox(width: 10),
//        IconButton(icon: Icon(Icons.content_copy,color: Colors.grey),
//          onPressed: () {
//            ClipboardManager.copyToClipBoard(code).then((value){
//              final snackBar = SnackBar(content: Text('Copied to clipboard'),duration: Duration(seconds: 2),);
//              _scaffoldKey.currentState.showSnackBar(snackBar);
//            });
//          }
//        )
          ],
        ),
      );

  Future<void> _selectClassAction(String value, String code) {
    switch (value) {
      case 'show code':
        showDialog(
            context: context, builder: (context) => _alertShowCode(code));
        break;
      default:
    }
  }

  // Future<void> deleteClass() async {
  //   await Firestore.instance.collection('Classrooms/$code/Students').getDocuments().then(
  //     (snapshot){
  //       for(DocumentSnapshot doc in snapshot.documents){
  //           doc.reference.delete();
  //         }
  //       });
  //   await Firestore.instance
  //     .collection("Status")
  //     .document(currentUser.email)
  //     .updateData({"Current class code": "NA"});
  // }

  AlertDialog leaveClassAlert(String email, String code) {
    return AlertDialog(
      title: Text('Leave this class?'),
      actions: [
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('NO')),
        FlatButton(
            onPressed: () async {
              await _leaveClass(email, code);
              Navigator.pushNamedAndRemoveUntil(
                  context, Intermediate.id, (route) => false);
            },
            child: Text('YES'))
      ],
    );
  }

  Map reversed = Info.getBranch().map((k, v) => MapEntry(v, k));

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: mainColor,
            titleSpacing: 2,
            title: Text(
                data.currentClassCode.substring(0, 1) == 'b'
                    ? 'Batch-${data.currentClassCode.substring(1, 2)}'
                    : reversed[data.currentClassCode.substring(0, 2)] +
                        ' ' +
                        Info.yrs[
                            int.parse(data.currentClassCode.substring(5, 6)) -
                                2],
                style: TextStyle(letterSpacing: 1, fontSize: 21)),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async => await showDialog(
                      context: context,
                      builder: (context) => leaveClassAlert(
                          data.currentEmail, data.currentClassCode))),
              // Scaffold.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text("Coming soon :)"),
              //     backgroundColor: Colors.green,
              //     duration: Duration(milliseconds: 1500),
              //   ),
              // );
              //  showSearch(context: context, delegate: SearchNames(searchCode: code))
              if (data.isCr)
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      // PopupMenuItem(value: 'blockunblock',child: Text(status == null ? 'Loading...' : status ? 'Unblock' : 'Block'))
                      PopupMenuItem(
                          value: 'show code', child: Text('View code'))
                    ];
                  },
                  onSelected: (String val) =>
                      _selectClassAction(val, data.currentClassCode),
                )
            ],
          ),
          body: Scrollbar(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('Classrooms/${data.currentClassCode}/Students')
                    .orderBy('name', descending: false)
                    .snapshots(),
                builder: (context, dataSnapShot) {
                  if (dataSnapShot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  final studentDocs = dataSnapShot.data.documents;
                  return ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        //display roll no
                        data.isCr
                            ? Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  studentDocs[index]['roll number'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                backgroundColor: mainColor,
                                duration: Duration(seconds: 5)))
                            : null;
                      },
                      title: Text(
                        studentDocs[index]['name'],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: data.name == studentDocs[index]['name']
                                ? Colors.blue
                                : Colors.grey[800]),
                      ),
                      leading: Icon(
                        Icons.person_outline,
                        color: mainColor,
                        size: 28,
                      ),
                      // trailing: data.isCr ? Member() : null,
                      trailing: studentDocs[index]['CR']
                          ? Text(
                              'CR   ',
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          : data.isCr
                              ? data.name != studentDocs[index]['name']
                                  ? PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.grey[700],
                                      ),
                                      onSelected: (String val) => _selectAction(
                                          val,
                                          data.currentClassCode,
                                          data.currentEmail,
                                          studentDocs[index]['name'],
                                          studentDocs[index]['email']),
                                      itemBuilder: (context) =>
                                          <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                                value: 'CR',
                                                child: Text('Add as CR')),
                                            // PopupMenuItem<String>(
                                            //   value: 'Remove',
                                            //   child: Text('Remove user')
                                            // )
                                          ])
                                  : null
                              : null,
                    ),
                    itemCount: studentDocs.length,
                  );
                }),
          ),
        );
      },
    );
  }
}

class Member extends StatelessWidget {
  final Function selectAction;

  Member({this.selectAction});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[700],
        ),
        onSelected: (String val) => selectAction(val),
        itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  value: 'Add as CR', child: Text('Add as CR')),
              PopupMenuItem<String>(value: 'remove', child: Text('Remove user'))
            ]);
  }
}

//Adding search functionality(optional)
// class SearchNames extends SearchDelegate<String>{
//   final String searchCode;

//   SearchNames({@required this.searchCode});

//   @override
//   List<Widget> buildActions(BuildContext context) {

//       return [IconButton(icon: Icon(Icons.clear), onPressed: (){
//         query = "";
//       })];
//     }

//     @override
//     Widget buildLeading(BuildContext context) {

//       return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
//         close(context, null);
//       });
//     }

//     @override
//     Widget buildResults(BuildContext context) {
//       return ListView();
//     }

//     @override
//     Widget buildSuggestions(BuildContext context) {
//       final list = query.isEmpty ? listStudent : listStudent.where((element) => element.startsWith(query.substring(0,1).toUpperCase()+query.substring(1,query.length))).toList();

//       return StreamBuilder(stream: Firestore.instance.collection('Classrooms/$searchCode/Students').snapshots(),builder: (context,dataSnapShot){
//         return ListView.builder(itemBuilder: (context,index) => ListTile(
//           onTap: (){},
//           title: RichText(text: TextSpan(
//             text: list[index].substring(0,query.length),
//             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
//             children: [TextSpan(
//               text: list[index].substring(query.length),
//               style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.grey[800])
//             )]
//           )),
//           leading: Icon(Icons.person_outline,color: mainColor,),
//         ),
//       itemCount: list.length,
//       );
//     });
//   }
// }
