import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';

class ResetPassword extends StatelessWidget {
  static String id = "resetpass";
  final _auth = FirebaseAuth.instance;
  final emailcon = TextEditingController();
  String error = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Reset Password',
                    style: TextStyle(
                      fontSize: 25,
                      color: mainColor,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 30),
                Container(
                  constraints: BoxConstraints(maxWidth: 270),
                  child: Text(
                    'Enter your email address so that we can send a password reset link to your email address',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 30),
                CodeFields("Email", TextInputType.emailAddress, emailcon),
                SizedBox(
                  height: 15,
                ),
                button("Submit", 18, () async {
                  if (emailcon.text.isEmpty)
                    Flushbar(
                      messageText: Text(
                        "Enter your email",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      icon: errorIcon,
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    )..show(context);
                  try {
                    await _auth.sendPasswordResetEmail(email: emailcon.text);
                    Flushbar(
                      messageText: Text(
                        "Password reset link has been sent to ${emailcon.text}",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.black,
                      ),
                      duration: Duration(seconds: 4),
                      backgroundColor: Colors.yellow[600],
                    )..show(context);
                  } catch (e) {
                    error = getError(e);
                    print(error);
                    Flushbar(
                      messageText: Text(
                        error,
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    )..show(context);
                  }
                }),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(5),
                  child: FlatButton(
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, SignIn.id),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
