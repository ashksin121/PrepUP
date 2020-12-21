import 'dart:collection';
import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

final List<String> imgList = [
  'https://static.vecteezy.com/system/resources/previews/000/271/899/non_2x/education-online-training-courses-distance-education-vector-illustration.jpg',
  'https://i.pinimg.com/originals/4b/4b/c8/4b4bc8f0e26e86fcbdfb5b7a898ee910.jpg',
  'https://previews.123rf.com/images/liravega258/liravega2581801/liravega258180100038/94231330-education-online-training-courses-distance-education-vector-illustration-internet-studying-online-bo.jpg',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  'https://img.freepik.com/free-vector/online-community-courses-tutorials_23-2148515124.jpg?size=626&ext=jpg',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

Random random = new Random();

Map<String, dynamic> courses;
Map<String, dynamic> profile;
var allCourses = [], allCompleted = [], allIncomplete = [];
String idx =
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';
List<Widget> imageSliders, incomplete, completed;
void main() => runApp(CarouselDemo());

class CarouselDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarouselWithIndicatorDemo(),
    );
  }
}

// var qq = Map<String, dynamic>.from(courses);
// if(allCourses.runtimeType==)

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  // var courses = {};

  @override
  void initState() {
    super.initState();
    print("hello");
    void fetchAlbum() async {
      final response =
          await http.get('http://0966f8c2615c.ngrok.io/getAllCourses');
      // final responseAvatars =
      //     await http.get('http://0966f8c2615c.ngrok.io/getAvatars');
      Map data = {"uid": "Tc5mg8twPOPVPIWXHd0AycemlSb2"};
      String body = json.encode(data);

      final profileResponse = await http.post(
        'http://0966f8c2615c.ngrok.io/fetchProfile',
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200 && profileResponse.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print((jsonDecode(response.body)));
        setState(() {
          courses = jsonDecode(response.body);
          print(courses.runtimeType);
          print(courses["aaa1a-7"]);
          // avatars = jsonDecode(responseAvatars.body);
          // print(avatars);
          profile = jsonDecode(profileResponse.body);
          allCompleted = profile["coursesCompleted"];
          allIncomplete = profile["coursesIncomplete"];
          print(profile);
        });
        var courseList = [];
        courses.forEach((key, value) {
          var mp = {};
          mp["courseid"] = key;
          mp["values"] = value;
          courseList.add(mp);
        });
        // print(avatars[courseList[0]["values"]["instructorId"]] == null);
        setState(() {
          allCourses = courseList;
          print(allCourses.toString());
        });

        final List<Widget> imageSlider = allCourses
            .map((item) => Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(imgList[random.nextInt(6)],
                                // avatars[item["values"]["instructorId"]]
                                // avatars["Tc5mg8twPOPVPIWXHd0AycemlSb2"],
                                // != null
                                //     ? avatars[
                                //         avatars["Tc5mg8twPOPVPIWXHd0AycemlSb2"]]
                                //     : idx,
                                fit: BoxFit.cover,
                                width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  item["values"]["title"],
                                  // 'No. ${imgList.indexOf(item)} image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ))
            .toList();

        final List<Widget> courseCompleted = allCompleted
            .map((item) => Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(imgList[random.nextInt(6)],
                                // avatars[item["values"]["instructorId"]]
                                // avatars["Tc5mg8twPOPVPIWXHd0AycemlSb2"],
                                // != null
                                //     ? avatars[
                                //         avatars["Tc5mg8twPOPVPIWXHd0AycemlSb2"]]
                                //     : idx,
                                fit: BoxFit.cover,
                                width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  item,
                                  // 'No. ${imgList.indexOf(item)} image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ))
            .toList();

        final List<Widget> courseIncomplete = allIncomplete
            .map((item) => Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(imgList[random.nextInt(6)],
                                // avatars[item["values"]["instructorId"]]
                                // avatars["Tc5mg8twPOPVPIWXHd0AycemlSb2"],
                                // != null
                                //     ? avatars[
                                //         avatars["Tc5mg8twPOPVPIWXHd0AycemlSb2"]]
                                //     : idx,
                                fit: BoxFit.cover,
                                width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  item,
                                  // 'No. ${imgList.indexOf(item)} image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ))
            .toList();

        setState(() {
          imageSliders = imageSlider;
          completed = courseCompleted;
          incomplete = courseIncomplete;
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        // throw Exception('Failed to load album');
      }
    }

    fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(
            child: Text(
          "All Courses",
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 20,
          ),
        )),
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 3.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: allCourses.map((url) {
            int index = allCourses.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
        Center(
            child: Text(
          "Completed",
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 20,
          ),
        )),
        CarouselSlider(
          items: completed,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 4.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: completed.map((url) {
            int index = completed.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
        Center(
            child: Text(
          "Incomplete",
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 20,
          ),
        )),
        CarouselSlider(
          items: incomplete,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 4.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: incomplete.map((url) {
            int index = incomplete.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
