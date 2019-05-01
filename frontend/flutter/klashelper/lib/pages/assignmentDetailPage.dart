import 'package:flutter/material.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AssignmentDetailPage extends StatefulWidget {
  final Assignment assignment;
  AssignmentDetailPage({Key key, @required this.assignment}) : super(key: key);

  @override
  AssignmentDetailPageState createState() => new AssignmentDetailPageState();
}

class AssignmentDetailPageState extends State<AssignmentDetailPage> {
  static const _primaryColor = const Color(0xFF0D326F);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("빌드띠");
    return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("과제 정보"),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.download),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.trash),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: Text(widget.assignment.toJson().toString()),
        ),
    );
  }
}

