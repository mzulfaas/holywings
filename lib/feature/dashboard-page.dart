import 'package:flutter/material.dart';

import '../author/author-page.dart';
import '../book/book-page.dart';
import '../genre/genre-page.dart';
import '../member/member-page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List pages = [
      GenrePage(),
      AuthorPage(),
      BookPage(),
      MemberPage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        selectedIconTheme: IconThemeData(color: Colors.red),
        currentIndex: _selectedItemIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
            _selectedItemIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            title: Text("Genre",
              textAlign: TextAlign.center,
              style: TextStyle(
              ),
            ),
            icon: Icon(Icons.map,
            ),
          ),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            title: Text("Author",
              textAlign: TextAlign.center,
              style: TextStyle(
              ),
            ),
            icon: Icon(Icons.people,
            ),
          ),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            title: Text("Book",
              textAlign: TextAlign.center,
              style: TextStyle(
              ),
            ),
            icon: Icon(Icons.book,
            ),
          ),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            title: Text("Member",
              textAlign: TextAlign.center,
              style: TextStyle(
              ),
            ),
            icon: Icon(Icons.person,
            ),
          ),
        ],
      ),
      body: pages[_selectedItemIndex??""],
    );
  }
}
