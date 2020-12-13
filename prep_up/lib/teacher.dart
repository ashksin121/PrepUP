import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:prep_up/addcourse.dart';

class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          item(
            'Demo Course6',
            'IN REVIEW',
          ),
          item(
            'Demo Course5',
            'ACCEPTED',
          ),
          item(
            'Demo Course4',
            'ACCEPTED',
          ),
          item(
            'Demo Course3',
            'REJECTED',
          ),
          item(
            'Demo Course2',
            'ACCEPTED',
          ),
          item(
            'Demo Course1',
            'ACCEPTED',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: 'Add Courses',
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.add,
            onPress: () {
              _animationController.reverse();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddCourse();
              }));
            },
          ),
          Bubble(
            title: 'Add Quizzes',
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.add,
            onPress: () {
              _animationController.reverse();
            },
          ),
        ],
        animation: _animation,
        onPress: _animationController.isCompleted
            ? _animationController.reverse
            : _animationController.forward,
        iconColor: Colors.white,
        backGroundColor: Colors.blue,
        animatedIconData: AnimatedIcons.menu_arrow,
      ),
    );
  }
}

Widget item(String courseTitle, String status) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: ListTile(
      leading: Icon(Icons.library_books),
      title: Text(
        courseTitle,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: statusOfCourse(status),
    ),
  );
}

Widget statusOfCourse(String status) {
  Color v;
  if (status == "REJECTED")
    v = Colors.red;
  else if (status == "ACCEPTED")
    v = Colors.green;
  else
    v = Colors.blue;

  return Text(
    status,
    style: TextStyle(color: v, fontWeight: FontWeight.bold),
  );
}

//
//Column(
//mainAxisAlignment: MainAxisAlignment.end,
//children: <Widget>[
//Transform(
//transform: Matrix4.translationValues(
//0.0,
//_translateButton.value * 3.0,
//0.0,
//),
//child: addcourse(),
//),
//Transform(
//transform: Matrix4.translationValues(
//0.0,
//_translateButton.value * 2.0,
//0.0,
//),
//child: addquiz(),
//),
//toggle(),
//],
//)
