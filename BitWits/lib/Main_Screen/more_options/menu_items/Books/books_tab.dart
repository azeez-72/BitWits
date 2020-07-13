import 'package:bitwitsapp/Main_Screen/more_options/menu_items/Books/BSR/BSR_display_list.dart';
import 'package:bitwitsapp/Main_Screen/more_options/menu_items/Books/BSR/MyBSR.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';

class BooksTab extends StatefulWidget {
  static final String id = "books_tab";

  @override
  _BooksTabState createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> with TickerProviderStateMixin {

  ScrollController _scrollViewController = ScrollController();

  List<Widget> pages = [
    BSRdisplay(),
    MyBSR()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: mainColor,
                actions: [
                  IconButton(icon: Icon(Icons.search), onPressed: (){
                    //search for items
                  })
                ],
                title: Text('Books',style: TextStyle(color: Colors.white),),
                pinned: true,
                floating: true,
                snap: true,
                elevation: 10,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: <Tab>[
                    Tab(text: "REQUESTS"),
                    Tab(text: "MY REQUESTS"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}