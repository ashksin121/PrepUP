import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

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
