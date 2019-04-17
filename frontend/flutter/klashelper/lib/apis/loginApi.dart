import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klashelper/models/loginStatus.dart';

const baseUrl = "http://klashelper.ryulth.com/login";
Map <String, String> requestHeaders = {
  "Content-Type": "application/json",
  'appToken' : 'test'
};

class LoginApi {
  Future<LoginStatus> getLogin(Map data) async{
    var requestBody = json.encode(data);
    final response = await http.post(baseUrl,
    headers: requestHeaders,
    body: requestBody
  );
  final int statusCode = response.statusCode;
  if (statusCode < 200 || statusCode > 400 ||json == null) {
        throw new Exception("Error while fetching data");
  }
  return LoginStatus.fromJson(json.decode(response.body));
  }
}