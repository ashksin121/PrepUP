import 'package:flutter/material.dart';

class Student extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button('Browse'),
          SizedBox(
            height: 100,
          ),
          Button('Completed'),
        ],
      ),
    );
  }
}

Widget Button(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Container(
      height: 150,
      width: double.infinity,
      child: FlatButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.blue),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 30),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
        onPressed: () {},
      ),
    ),
  );
}
