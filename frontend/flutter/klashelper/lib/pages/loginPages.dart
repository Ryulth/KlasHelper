import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klashelper/response/loginResponse.dart';
import 'dart:convert';
import 'assignmentPage.dart';
import 'package:klashelper/models/user.dart';
import 'package:klashelper/apis/loginApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  User user = new User();
  DateTime lastTimeBackPressed = DateTime.fromMicrosecondsSinceEpoch(0);

  Future<bool> _onWillPop() async {
    if (DateTime.now().difference(lastTimeBackPressed) < Duration(seconds: 2)) {
      SystemNavigator.pop();
      return Future.value(true);
    }
    //'뒤로' 버튼 한번 클릭 시 메시지
    //Toast.makeText(this, "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.", Toast.LENGTH_SHORT).show();
    lastTimeBackPressed = DateTime.now();
    return Future.value(false);
  }

  Future<Null> _getLogin() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // form 저장
      if (await _isLogin()) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userInfoFile", json.encode(user.toJson()));
        Navigator.pushNamedAndRemoveUntil(
            context, '/assignmentPage', (_) => false);
      }
    }
  }

  Future<bool> _isLogin() async {
    LoginResponse loginStatus = await LoginApi().getLogin(user.toJson());
    if (loginStatus.flag == 1) {
      //로그인 성공 TODO enum
      print("로그인성공");
      return true;
    }
    print("로그인실패");
    return false;
  }

  String _validateData(String value) {
    if (value.length < 1) {
      return "필수 입력 입니다.";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  static const _primaryColor = const Color(0xFF0D326F);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
// TODO: implement build
    return WillPopScope(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: _primaryColor,
        ),
        home: Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: new Text('Login'),
          ),
          body: new Container(
              padding: new EdgeInsets.all(20.0),
              child: new Form(
                key: this._formKey,
                child: new ListView(
                  children: <Widget>[
                    new TextFormField(
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                            hintText: 'ID', labelText: 'Enter your id'),
                        validator: this._validateData,
                        onSaved: (String id) {
                          user.id = id;
                        }),
                    new TextFormField(
                      obscureText: true, // Use secure text for passwords.
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          labelText: 'Enter your password'),
                      validator: this._validateData,
                      onSaved: (String pw) {
                        user.pw = pw;
                      },
                    ),
                    new Container(
                      width: screenSize.width,
                      child: new RaisedButton(
                        child: new Text(
                          'Login',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await _getLogin();
                        },
                        color: _primaryColor,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    )
                  ],
                ),
              )),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }
}
