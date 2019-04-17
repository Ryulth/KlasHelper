import 'package:flutter/material.dart';
import 'assignmentPage.dart';
import 'package:klashelper/models/user.dart';
import 'package:klashelper/apis/loginApi.dart';
import 'package:klashelper/models/loginStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  
  @override
  LoginPageState createState() => new LoginPageState();
}
class LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  User user = new User();
  Future<Null> _getLogin() async{
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();// form 저장
      print(user.toJson());
      print(user.toString());
      print(user.id);
      print("get Lopgin");
      if(await _isLogin()){
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AssignmentPage(); 
        }));
      }
    }
  }
  Future<bool> _isLogin() async{
    LoginStatus loginStatus = await  LoginApi().getLogin(user.toJson());
      if(loginStatus.flag==1){//로그인 성공 TODO enum 
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", user.id);
        prefs.setString("userPW", user.pw);
        print("로그인성공");
        return true;
      }
    print("로그인실패");
    return false;
  }
  Future<Null> _loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //final String jsonString = prefs.getString("userInfoFile");
    final String userId = prefs.getString("userId");
    final String userPW = prefs.getString("userPW");
    if (userId != null && userId.isNotEmpty) {
       print(userId);
       user.id =userId;
       user.pw =userPW;
       print(user.toJson().toString());
       if(await _isLogin()){
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AssignmentPage(); 
          }));
       }
    }
    // default value
  }
  String _validateData(String value){
    if(value.length<1){
      return "필수 입력 입니다.";
    }
    return null;
  }
  @override
  void initState() {
      super.initState();
      print("initstate");
      _loadUser();
  } 

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
// TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'ID',
                        labelText: 'Enter your id'
                    ),
                    validator: this._validateData,
                    onSaved: (String id){
                      user.id = id;
                    }
                ),
                new TextFormField(
                    obscureText: true, // Use secure text for passwords.
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        labelText: 'Enter your password'
                    ),
                    validator: this._validateData,
                    onSaved: (String pw){
                      user.pw = pw;
                    },
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Login',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: () async {
                        await _getLogin();
                    },
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
