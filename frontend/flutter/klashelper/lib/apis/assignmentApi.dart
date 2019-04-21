import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klashelper/response/assignmentResponse.dart';
import 'package:klashelper/models/user.dart';

const baseUrl = "http://klashelper.ryulth.com/assignments/";
Map<String, String> requestHeaders = {'appToken': 'test', 'id': '', 'pw': ''};

class AssignmentApi {
  Future<AssignmentResponse> getAssignment(
      User user, String semesterCode) async {
    requestHeaders['id'] = user.id;
    requestHeaders['pw'] = user.pw;
    print(semesterCode);
    final response = await http.get(
      baseUrl + semesterCode,
      headers: requestHeaders,
    );
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return AssignmentResponse.fromJson(json.decode(response.body));
  }
}
