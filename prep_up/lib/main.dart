import 'package:flutter/material.dart';
import 'package:prep_up/addQuiz.dart';
import 'package:prep_up/addcourse.dart';
import 'package:prep_up/courseDetails.dart';
import 'package:prep_up/custom/quiz.dart';
// import 'package:prep_up/home.dart';
// import 'package:prep_up/signin.dart';
// import 'package:prep_up/teacher.dart';
import './custom/signin.dart';
import 'custom/student.dart';
import 'custom/cards.dart';
import './custom/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Quiz(),
    );
  }
}
