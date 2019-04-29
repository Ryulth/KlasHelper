import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AssignmentDetailPage extends StatefulWidget{
  AssignmentDetailPage({Key key}) : super(key: key);

  @override
  AssignmentDetailPageState createState() => new AssignmentDetailPageState();
}

class AssignmentDetailPageState extends State<AssignmentDetailPage>{
  static const _primaryColor = const Color(0xFF0D326F);
  @override
  Widget build(BuildContext context) {
    print("빌드띠");
    return WillPopScope(
      child: Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
      ),
      onWillPop: (){
        print("toudch");
        Navigator.pop(context);},
    );
    // TODO: implement build
//    return MaterialApp(
//      theme: ThemeData(
//        primaryColor: _primaryColor,
//      ),
//      home: Scaffold(
//        appBar: AppBar(
//          automaticallyImplyLeading:true,
//          title: Text("과제 정보"),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(FontAwesomeIcons.download),
//              onPressed: (){},
//            ),
//            IconButton(
//              icon: Icon(FontAwesomeIcons.trash),
//              onPressed: (){},
//            ),
//          ],
//        ),
//      ),
//
//    );

  }

}