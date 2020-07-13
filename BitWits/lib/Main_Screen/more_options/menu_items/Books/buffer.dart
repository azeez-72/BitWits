import 'package:bitwitsapp/Main_Screen/more_options/menu_items/Books/books_tab.dart';
import 'package:bitwitsapp/Main_Screen/more_options/menu_items/Books/phone_auth.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Buffer extends StatefulWidget {
  static final String id = 'buffer';

  @override
  _BufferState createState() => _BufferState();
}

class _BufferState extends State<Buffer> {
  final _user = FirebaseAuth.instance.currentUser();

  @override
  void initState() {
    _user.then((user) {
      if(user.phoneNumber != null) Navigator.popAndPushNamed(context, BooksTab.id);
      else Navigator.popAndPushNamed(context, PhoneAuth.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}