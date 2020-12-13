import 'package:flutter/material.dart';
import 'package:prep_up/student.dart';
import 'package:prep_up/teacher.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PepUp'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.wb_iridescent),
              ),
              Tab(
                icon: Icon(Icons.label),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [Teacher(), Student()],
        ),
      ),
    );
  }
}
