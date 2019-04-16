import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klashelper/models/user.dart';
const baseUrl = "http://klashelper.ryulth.com/login";

class LoginApi {
  Future<String> getLogin(Map body) async{
    return http.post(baseUrl,body: body).then((http.Response response){
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 ||json == null) {
        throw new Exception("Error while fetching data");
      }
      return json.decode(response.body);
    });

  }
}