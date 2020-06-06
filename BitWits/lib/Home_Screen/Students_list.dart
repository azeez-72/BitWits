import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitwitsapp/info.dart';


List<String> listStudent = [];

class Students_list extends StatefulWidget {
  static String id = "students_list";

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

    getClassList();
  }

  //get year and branch from shared preference code
  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      code = prefs.getString(currentUser.email);
      year = code.substring(5,6);
      if(year == "1") batch = code.substring(1,2);
      else {
        Map reversed = Info.getBranch().map((k, v) => MapEntry(v, k));
        String b = code.substring(0,2);
        branch = reversed[b];
      }
    });
  }

  //get students list from DB
  Future<void> getClassList() async{
    await registeredCurrentUser();
    await getDetails();
    var re =  RegExp('(?<=name:)(.*?)(?=,)');
    try{
      if(year == "1")
      data = await DBRef.child("Year $year/Batch $batch").once().then((DataSnapshot snapshot) => snapshot.value.toString());
      else data = await DBRef.child("Year $year/Batch $branch").once().then((DataSnapshot snapshot) => snapshot.value.toString());
    } catch(e){
      print(e);
    }
    Iterable match = re.allMatches(data);
    setState(() {
      match.forEach((match) {
      listStudent.add(data.toString().substring(match.start,match.end).trim());
      });
      print(listStudent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
           _auth.signOut();
           Navigator.pushNamed(context, SignIn.id);
         }),
         backgroundColor: mainColor,
         titleSpacing: 2,
         title: Text("Classmates",style: TextStyle(letterSpacing: 1,fontSize: 21)), 
         actions: <Widget>[
           IconButton(icon: Icon(Icons.search),onPressed:(){
             showSearch(context: context, delegate: SearchNames());
           },),
         ],
       ),
       body: Container(
         padding: EdgeInsets.symmetric(horizontal: 8),
         color: Colors.white,
         child: listStudent.isEmpty? Center(child:Text("Loading...",style: TextStyle(fontSize: 32),),) : ListView.builder(itemBuilder: (context,index) => ListTile(
           onTap: (){},
           title: Text(listStudent[index],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.grey[800]),),
           leading: Icon(Icons.person_outline,color: mainColor,), 
         ),
         itemCount: listStudent.length
         )
       ),
    ); 
  }
}



//Adding search functionality(optional)
class SearchNames extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {

      return [IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      })];
    }
  
    @override
    Widget buildLeading(BuildContext context) {

      return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
        close(context, null);
      });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return ListView();
    }
    String a;
    @override
    Widget buildSuggestions(BuildContext context) {
      final list = query.isEmpty ? listStudent : listStudent.where((element) => element.startsWith(query.substring(0,1).toUpperCase()+query.substring(1,query.length).toLowerCase())).toList();

      return ListView.builder(itemBuilder: (context,index) => ListTile(
        onTap: (){},
        title: RichText(text: TextSpan(
          text: list[index].substring(0,query.length),
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
          children: [TextSpan(
            text: list[index].substring(query.length),
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.grey[800])
          )]
        )),
        leading: Icon(Icons.person_outline,color: mainColor,),
      ),
      itemCount: list.length,
    );
  }
}

//TODO: onTap display roll number functionality