import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klashelper/response/semesterResponse.dart';
import 'package:klashelper/models/user.dart';

const baseUrl = "http://klashelper.ryulth.com/semesters";
Map<String, String> requestHeaders = {'appToken': 'test', 'id': ''};

class SemesterApi {
  Future<SemesterResponse> getSemester(User user) async {
    requestHeaders['id'] = user.id;
    print(requestHeaders.toString());
    final response = await http.get(
      baseUrl,
      headers: requestHeaders,
    );
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    print(json.decode(response.body));
    return SemesterResponse.fromJson(json.decode(response.body));
  }
}
