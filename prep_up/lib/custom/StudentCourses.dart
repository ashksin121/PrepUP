import 'package:flutter/material.dart';
import './cards.dart';

class StudentCourses extends StatefulWidget {
  @override
  _StudentCoursesState createState() => _StudentCoursesState();
}

class _StudentCoursesState extends State<StudentCourses> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: Column(children: [CarouselDemo()]));
    return CarouselDemo();
    // return MaterialApp(
    //     home: Scaffold(
    //   body: Column(
    //     children: [CarouselDemo()],
    //   ),
    // ));
  }
}
