import 'package:flutter/material.dart';
import 'package:klashelper/pages/assignmentFactory.dart';

class AssignmentTodo extends AssignmentFactory {
  AssignmentTodo() : super.create();

  final assignments = ["과제1", "과제2"];
  final isSwitches = [false, false];

  @override
  AssignmentTodoState createState() => AssignmentTodoState();
}

class AssignmentTodoState extends State<AssignmentTodo> {
  Future<void> _onRefresh() async{
    await Future.delayed(Duration(seconds: 3));
    print("refresh");
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _getList();
  }

  Widget _getList() {
    return //RefreshIndicator(
      //onRefresh: _onRefresh,
      ListView.builder(
        itemCount: widget.assignments.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                print(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    _getColumn(index),
                    _getSwitch(index),
                  ],
                ),
              ),
            ),
          );
        },
      );
    //);
  }

  Widget _getColumn(int index) {
    Widget column = Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '데이터 센터 프로그래밍',
            style: TextStyle(fontSize: 8),
          ),
          Text(
            widget.assignments[index] + "진행",
            style: TextStyle(fontSize: 16),
          ),
          Text('마감기한'),
        ],
      ),
    );
    return column;
  }

  Switch _getSwitch(int index) {
    return Switch(
      onChanged: (bool newValue) {
        print(newValue);
        setState(() {
          widget.isSwitches[index] = newValue;
          print(widget.isSwitches.toString());
        });
      },
      value: widget.isSwitches[index],
    );
  }
}
