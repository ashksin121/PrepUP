import 'dart:convert';

/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:prep_up/bazaar.dart';
import 'package:prep_up/teacher.dart';
import 'dart:convert';
import './cards.dart';
import '../addcourse.dart';
import './profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Student());
}

/// This is the main application widget.
class Student extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // void initState() {
  //   super.initState();
  //   WidgetsFlutterBinding.ensureInitialized();
  //   Firebase.initializeApp().whenComplete(() => {
  //         FirebaseFirestore.instance
  //             .collection('prepup')
  //             .doc("courses")
  //             .get()
  //             .then((value) => print(value))
  //       });
  //   // fx();
  // }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    // Text(
    //   'Index 0: Home',
    //   style: optionStyle,
    // ),

    CarouselDemo(),
    Teacher(),
    ProfilePage(),
    Bazaar(),
    // Text(
    //   'Index 1: Business',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index BottomNavigationBarType: School',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future<DocumentSnapshot> user;
    // Firebase.initializeApp().whenComplete(() => {
    //       FirebaseFirestore.instance
    //           .collection('prepup')
    //           .doc("courses")
    //           .get()
    //           .then((value) {
    //         print(value.data());
    //       })
    //     });

    // Future<http.Response>  fetchAlbum() async {
    // final response = http.get('http://localhost:8080/getAllCourses');
    // print(response);
    // return ();
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PrepUP'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),

      // child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Teach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Profile',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Bazaar')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
