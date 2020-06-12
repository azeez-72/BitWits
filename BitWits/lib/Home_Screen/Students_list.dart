import 'package:bitwitsapp/Navigate.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitwitsapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Students_list extends StatefulWidget {
  @override
  _Students_listState createState() => _Students_listState();
}

class _Students_listState extends State<Students_list> {
  String year,batch,code,branch;
  String data;
  final DBRef = FirebaseDatabase.instance.reference().child("Students");
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  Future<void> registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    setState(() {
    currentUser = regUser;
    });
  }

  @override
  void initState(){
    super.initState();

    getCode();
  }

  Future<void> getCode() async {
    await registeredCurrentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      code = prefs.getString(currentUser.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         leading: IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
           _auth.signOut();
           Navigator.popAndPushNamed(context, SignIn.id);
         }),
         backgroundColor: mainColor,
         titleSpacing: 2,
         title: Text("Classmates",style: TextStyle(letterSpacing: 1,fontSize: 21)), 
         actions: <Widget>[
           IconButton(icon: Icon(Icons.search),onPressed:(){
             Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Coming soon :)"),
                backgroundColor: Colors.green,
                duration: Duration(milliseconds: 1500),
                ),
              );
            //  showSearch(context: context, delegate: SearchNames(searchCode: code));
           },),
           IconButton(icon: SvgPicture.asset('svgs/personr.svg',width: 24,height: 24,),onPressed: (){
             //TODO: remove person from the list
           },)
         ],
       ),
       body: StreamBuilder(stream: Firestore.instance.collection('Classrooms/$code/Students').snapshots(),
       builder: (context,dataSnapShot){
        if(dataSnapShot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
        final studentDocs = dataSnapShot.data.documents;
        return ListView.builder(itemBuilder: (context,index) => ListTile(
          onTap: (){
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(studentDocs[index]['roll number'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: mainColor,duration: Duration(seconds: 5)));
          },
          title: Text(studentDocs[index]['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.grey[800]),),
          leading: Icon(Icons.person_outline,color: mainColor,size: 28,), 
          ),
          itemCount: studentDocs.length,
         );
       }),
    ); 
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
