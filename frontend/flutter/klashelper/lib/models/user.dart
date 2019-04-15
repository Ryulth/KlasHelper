import 'package:flutter/material.dart';
import 'package:lombok/lombok.dart';


@data
class User  {
  final String id;
  final String pw;

  User({this.id,this.pw});

  factory User.fromJason(Map<String,dynamic> json){
    return User(
      id : json['id'],
      pw : json['pw']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['pw'] = pw;

    return map;
  }
}