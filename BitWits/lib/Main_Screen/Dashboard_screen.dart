import 'package:bitwitsapp/Main_Screen/more_options/menu_list.dart';
import 'package:bitwitsapp/exports.dart';
import 'Announcements/Announcements.dart';
import 'Assignments/Assignments.dart';

int _selectedIndex = 1;

class Dashboard extends StatefulWidget {
  static String id = "stack";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> pages = [
    Announcements(),
    Assignments(),
    MenuList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: Container(
      //   color: Color(0xFFF8F8F8),
      //   child: TabBar(
      //     labelColor: mainColor,
      //     unselectedLabelColor: Color(0xFF828282),
      //     indicatorColor: Colors.transparent,
      //     indicatorWeight: 0.1,
      //     tabs: [
      //       Tab(
      //         text: 'Announcements',
      //         icon: Icon(Icons.announcement,size: 28,),
      //       ),
      //       Tab(
      //         text:'Assignments',
      //         icon: Icon(Icons.assignment,size: 28,),
      //       ),
      //       Tab(
      //         text: 'More',
      //         icon: Icon(Icons.more_horiz,size: 28,),
      //       )
      //     ]
      //   ),
      // ),
      bottomNavigationBar: bottomnavbar(
        onTap: (int index) => setState(() => _selectedIndex = index)),
      // body: TabBarView(children: pages),
      body: IndexedStack(
        children: pages,
        index: _selectedIndex,
      ),
    );
  }
}
  // final _auth = FirebaseAuth.instance;
  // FirebaseUser currentUser;
  
  // Future<void> registeredCurrentUser() async {
  //   final regUser = await _auth.currentUser();
  //   currentUser = regUser;
  //   await Firestore.instance
  //       .collection("Status")
  //       .document(currentUser.email)
  //       .get()
  //       .then((DocumentSnapshot snapshot) async {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     await preferences.setString(
  //         currentUser.email + "@", snapshot.data["Current class code"]);
  //   });
  // }

class bottomnavbar extends StatelessWidget {
  final Function onTap;

  bottomnavbar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavigationBar(
        selectedItemColor: mainColor,
        currentIndex: _selectedIndex,
        onTap: onTap,
        backgroundColor: Color(0xFFF8F8F8),
        iconSize: 32,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.announcement,
                color: _selectedIndex == 0 ? mainColor : Color(0xFF828282),
              ),
              title: Text("Announcements")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment,
                color: _selectedIndex == 1 ? mainColor : Color(0xFF828282),
              ),
              title: Text("Assignments")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz,
                color: _selectedIndex == 2 ? mainColor : Color(0xFF828282),
              ),
              title: Text("More")),
        ],
      ),
    );
  }
}
