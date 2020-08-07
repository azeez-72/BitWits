import 'package:bitwitsapp/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddBSR.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readmore/readmore.dart';

class MyBSR extends StatefulWidget {
  static final String id = 'my_books_reqs';

  @override
  _MyBSRState createState() => _MyBSRState();
}

class _MyBSRState extends State<MyBSR> {
  final _collectionRef = Firestore.instance.collection('BooksSellRequests');
  final _auth = FirebaseAuth.instance;
  String _phoneNo;
  int _totalRequests;

  _getPhoneNo() async => await _auth.currentUser().then((user) => setState(() => _phoneNo = user.phoneNumber));

  Future<void> _getTotalRequests() async {
    if(_phoneNo == null) return;
    await _collectionRef.where('Seller id',isEqualTo: _phoneNo).getDocuments().then((value){
      setState((){
        _totalRequests = value.documents.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getPhoneNo();
    _getTotalRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(Icons.add,color: Colors.white,size: 24,),
        onPressed: () => Navigator.pushNamed(context, AddBSR.id)
      ),
      // body: SafeArea(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
      //     child: ListView.builder(
      //       itemCount: _totalRequests,
      //       itemBuilder: (context,index) => Container(),
      //     )
      //   )
      // ),
    );
  }
}