import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:bitwitsapp/Main_Screen/more_options/menu_items/Books/books_tab.dart';
import 'package:bitwitsapp/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class PhoneAuth extends StatefulWidget {
  static final String id = 'phone_auth';
  
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _phoneNo,_verificationId,name,branch,year,currentText;
  bool codeSent = false,showSpinner = false;

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth){
      print('verified');
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
      setState(() => codeSent = true);
      this._verificationId = verId;
      _showOTPDialog(context);
    };

    final PhoneVerificationFailed verifyFailed = (AuthException e) {
      print('${e.message}');
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this._verificationId = verId;
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNo,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verifiedSuccess, 
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve
    );
  }

  _showOTPDialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => 
    StatefulBuilder(
      builder: (context,setState) => ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: AlertDialog(
          elevation: 24,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                textBaseline: TextBaseline.ideographic
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Enter the OTP that has been sent to '),
                TextSpan(text: _phoneNo,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))
              ]
            ),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PinField(onChanged: (value) => setState(() => currentText = value)),
                const SizedBox(height: 15),
                button(
                  'Submit',
                  18,
                  () async {
                    try{
                      setState(() => showSpinner = true);
                      await _linkWithOTP(currentText,context);
                    } catch(e){
                      setState(() => showSpinner = false);
                      print(e);
                    }
                  }
                )
              ],
            ),
          ),
        ),
      ),
    )
  ); 

  Future<void> _linkWithOTP(String smsCode,BuildContext context) async{
    final AuthCredential credentials = PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: smsCode);
    
    await _auth.currentUser().then((value) async {
      await value.linkWithCredential(credentials).then((AuthResult result) async {
        if(result.user != null){
          await Firestore.instance.collection('BooksSellIDs').document(_phoneNo).setData({
            'Name': name,
            'Branch': branch,
            'Year': year,
            'Blocked': false,
          });
          setState(() => showSpinner = false);
          Navigator.popAndPushNamed(context, BooksTab.id);
        } //store to db
      }).catchError((e){
        print(e); //handle exception
      });
    }).catchError((e){
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mobile = MediaQuery.of(context).size;
    return Consumer<Data>(
      builder: (context,data,child) =>
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(icon: Icon(Icons.arrow_back,color: mainColor,), onPressed: () => Navigator.pop(context)),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: mobile.height*0.04,left: 16,right: 16,bottom: 20),
            child: Column(
              children: [
                //insert title
                const Text('Setup your books account',style: TextStyle(fontSize: 24,color: mainColor),),
                SizedBox(height: mobile.height*0.1),
                Form(
                  key: _formKey,
                  child: TextFields('Phone Number', TextInputType.phone, Icon(Icons.phone_android),
                    (String value){
                      if(value.isEmpty) return 'Enter your phone number';
                      try{
                        if(value.substring(0,3) != '+91') return 'Enter country code +91 at the start of the number';
                        if(value.length != 13) return 'Invalid phone number';
                      }catch(e){return 'Invalid phone number';}
                      return null;
                    },
                    (String value) => _phoneNo = value.trim(),
                  )
                ),
                const SizedBox(height: 10),
                codeSent ? const Text('OTP sent!',style: TextStyle(color: Colors.green,fontSize: 14)) : Container(width: 0,height: 0),
                const SizedBox(height: 10),
                button(
                  'Verify',
                  18,
                  () async {
                    FocusScope.of(context).unfocus();
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        name = data.name;
                        branch = data.branch;
                        year = data.currentClassCode.substring(5,6);
                      });
                      await _verifyPhoneNumber(context);
                    }
                  }
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  child: Text('Why do we need to verify your number?',style: TextStyle(color: Colors.grey,decoration: TextDecoration.underline)),
                  onTap: (){},
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}