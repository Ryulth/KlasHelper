import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klashelper/response/loginResponse.dart';

const baseUrl = "http://klashelper.ryulth.com/assignments/";
Map <String, String> requestHeaders = {
  "Content-Type": "application/json",
  'appToken' : 'test'
};

class AssignmentApi {

  Future<LoginResponse> getAssignment(String semesterCode) async{
    final response = await http.get(baseUrl+semesterCode,
    headers: requestHeaders,
  );
  final int statusCode = response.statusCode;
  if (statusCode < 200 || statusCode > 400 ||json == null) {
        throw new Exception("Error while fetching data");
  }
  return LoginResponse.fromJson(json.decode(response.body));
  }
}

