import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

class NetworkManager {
  String baseURL = "https://prepup-api.herokuapp.com/";

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

  Future<String> fetchProfile(String uid, String name, String email) async {
    final data = jsonEncode({"uid": uid, "name": name, "email": email});
    final response = await http.post(
      '$baseURL/fetchProfile',
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: data,
    );
    print(response.body);
    return jsonDecode(response.body);
    // if (response.statusCode == 404) return {"status": "error"};
    // return jsonDecode(response.body);
  }
}
