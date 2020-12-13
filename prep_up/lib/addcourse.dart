import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prep_up/networkManager.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  @override
  final _formKey = GlobalKey<FormState>();
  List<String> tags = List<String>();
  final tagsController = TextEditingController();
  String title = '';
  String summary = '';
  List<File> file = List<File>();
  List<String> fileLinks = List<String>();
  String filename;
  NetworkManager networkManager = NetworkManager();

  Widget filesDisplay() {
    return file.length == 0
        ? Text('No Files Uploaded Yet')
        : Flexible(
            child: ListView.builder(
              itemCount: file.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(basename(file[index].path)),
                );
              },
            ),
          );
  }

  void filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    List<File> temp = result.paths.map((path) => File(path)).toList();
    file.addAll(temp);
    setState(() {});
  }

  void submitData() async {
    await Firebase.initializeApp();
    FirebaseAuth mAuth = FirebaseAuth.instance;
    FirebaseUser user = mAuth.currentUser;
    if (user != null) {
      // do your stuff
    } else {
      mAuth.signInAnonymously();
    }

    for (File i in file) {
      String temp = basename(i.path);
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('pdf/$temp')
            .putFile(i);
      } on firebase_storage.FirebaseException catch (e) {
        print(e);
      }

      String link = await firebase_storage.FirebaseStorage.instance
          .ref('pdf/$temp')
          .getDownloadURL();

      fileLinks.add(link);
    }

    await networkManager.createCourse(title, summary, tags, fileLinks);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
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
                    onChanged: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Title';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Summary',
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
                    onChanged: (value) {
                      summary = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Summary';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Tags',
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
                          controller: tagsController,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      RaisedButton(
                        child: Text('Add'),
                        onPressed: () {
                          setState(() {
                            tags.add(tagsController.text);
                            tagsController.text = '';
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Tags(
                    itemCount: tags.length,
                    itemBuilder: (int index) {
                      return ItemTags(
                        index: index,
                        title: tags[index],
                        removeButton: ItemTagsRemoveButton(onRemoved: () {
                          setState(() {
                            tags.removeAt(index);
                          });
                          return true;
                        }),
                      );
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  filesDisplay(),
                  RaisedButton(
                    child: Text('Select Files'),
                    onPressed: () {
                      filePicker();
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        submitData();
                      }
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
