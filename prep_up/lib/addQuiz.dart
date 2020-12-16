import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom/quizModel.dart';

List<Quiz> questions;

class AddQuiz extends StatefulWidget {
  @override
  _AddQuizState createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    questions = List<Quiz>();
  }

  final _formKey = GlobalKey<FormState>();
  final question = TextEditingController();
  final option1 = TextEditingController();
  final option2 = TextEditingController();
  final option3 = TextEditingController();
  final option4 = TextEditingController();
  final answer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Quiz'),
      ),
      body: Column(
        children: [
          questions.length > 0
              ? Flexible(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10.0),
                              shape: StadiumBorder(
                                side: BorderSide(width: 2, color: Colors.blue),
                              ),
                              title: Text(questions[index].question),
                              subtitle: Text(
                                  '${questions[index].options[0]}\n${questions[index].options[1]}\n${questions[index].options[2]}\n${questions[index].options[3]}\nCorrect : ${questions[index].options[questions[index].answer - 1]}'),
                              trailing: FlatButton(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  questions.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Click on + button to add questions!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: questions.length > 0 ? () {} : null,
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    content: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputField('Question', question),
                              SizedBox(
                                height: 20,
                              ),
                              InputField('Option 1', option1),
                              SizedBox(
                                height: 20,
                              ),
                              InputField('Option 2', option2),
                              SizedBox(
                                height: 20,
                              ),
                              InputField('Option 3', option3),
                              SizedBox(
                                height: 20,
                              ),
                              InputField('Option 4', option4),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: answer,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Answer(1,2,3 or 4)',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty ||
                                      int.tryParse(value) < 1 ||
                                      int.tryParse(value) > 4)
                                    return 'Enter Answer';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    actions: [
                      FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('ADD'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Quiz temp = new Quiz();
                            temp.question = question.text;
                            temp.options.add(option1.text);
                            temp.options.add(option2.text);
                            temp.options.add(option3.text);
                            temp.options.add(option4.text);
                            temp.answer = int.tryParse(answer.text);
                            questions.add(temp);
                            _formKey.currentState.reset();
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}

Widget InputField(String label, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
    validator: (value) {
      if (value.isEmpty) return 'Enter $label';
      return null;
    },
  );
}
