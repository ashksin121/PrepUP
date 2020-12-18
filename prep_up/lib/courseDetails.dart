import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class CourseDetails extends StatelessWidget {
  String title;
  String summary;
  List<String> tags;
  List<String> files;

  CourseDetails({this.title});

  @override
  Widget build(BuildContext context) {
    tags = List<String>();
    tags.add('one');
    tags.add('one');
    tags.add('one');
    files = List<String>();
    files.add('one');
    files.add('one');
    files.add('one');

    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'title',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Demo Summary',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Tags(
              itemCount: tags.length,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: tags[index],
                );
              },
            ),
            Flexible(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(files[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
