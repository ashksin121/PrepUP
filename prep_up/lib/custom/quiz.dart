import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<Widget> scoreKeeper;
  int score, currentQuestion;
  List<String> questions;
  List<String> option1, option2, option3, option4;
  List<int> answer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    score = 0;
    currentQuestion = 0;
    scoreKeeper = [];
    questions = [
      'Question1',
      'Question2',
    ];
    option1 = [
      'option11',
      'option12',
    ];
    option2 = [
      'option21',
      'option22',
    ];
    option3 = [
      'option31',
      'option32',
    ];
    option4 = [
      'option41',
      'option42',
    ];
    // 0-based indexing
    answer = [1, 0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      questions[currentQuestion],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                    textColor: Colors.white,
                    color: Colors.deepOrangeAccent,
                    child: Text(
                      option1[currentQuestion],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (answer[currentQuestion] == 0) {
                          score++;
                          scoreKeeper.add(Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                        } else {
                          scoreKeeper.add(Icon(
                            Icons.close,
                            color: Colors.red,
                          ));
                        }
                        if (currentQuestion == questions.length - 1) {
                          currentQuestion = 0;
                          scoreKeeper = [];
                          score = 0;
                        } else
                          currentQuestion++;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                    color: Colors.deepOrangeAccent,
                    child: Text(
                      option2[currentQuestion],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (answer[currentQuestion] == 1) {
                          score++;
                          scoreKeeper.add(Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                        } else {
                          scoreKeeper.add(Icon(
                            Icons.close,
                            color: Colors.red,
                          ));
                        }
                        if (currentQuestion == questions.length - 1) {
                          currentQuestion = 0;
                          scoreKeeper = [];
                          score = 0;
                        } else
                          currentQuestion++;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                    color: Colors.deepOrangeAccent,
                    child: Text(
                      option3[currentQuestion],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (answer[currentQuestion] == 2) {
                          score++;
                          scoreKeeper.add(Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                        } else {
                          scoreKeeper.add(Icon(
                            Icons.close,
                            color: Colors.red,
                          ));
                        }
                        if (currentQuestion == questions.length - 1) {
                          currentQuestion = 0;
                          scoreKeeper = [];
                          score = 0;
                        } else
                          currentQuestion++;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                    color: Colors.deepOrangeAccent,
                    child: Text(
                      option4[currentQuestion],
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (answer[currentQuestion] == 0) {
                          score++;
                          scoreKeeper.add(Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                        } else {
                          scoreKeeper.add(Icon(
                            Icons.close,
                            color: Colors.red,
                          ));
                        }
                        if (currentQuestion == questions.length - 1) {
                          currentQuestion = 0;
                          scoreKeeper = [];
                          score = 0;
                        } else
                          currentQuestion++;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: scoreKeeper,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
