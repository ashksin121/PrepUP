import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

class NetworkManager {
  String baseURL = "https://c429a79b0a1e.ngrok.io";

  Future<void> createCourse(String title, String summary, List<String> tags,
      List<String> docs) async {
    String tag = "";
    for (String i in tags) {
      tag += i;
      tag += ' ';
    }

    final data = jsonEncode(<String, dynamic>{
      "links": docs,
      "quizzes": ["A"],
      "summary": summary,
      "tags": tag,
      "title": title,
    });
    final body = jsonEncode(
      <String, dynamic>{
        "uid": "aaa1a",
        "data": data,
      },
    );

    final response = await http.post(
      '$baseURL/createCourse/aaa1a',
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: data,
    );

    print('body' + response.body);
  }
}
