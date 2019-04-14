import 'package:flutter/material.dart';
import 'assignmentFactory.dart';
class AssignmentTodo extends AssignmentFactory{
  AssignmentTodo(): super.create();
  @override
  AssignmentTodoState createState() => AssignmentTodoState();
}
class AssignmentTodoState extends State<AssignmentTodo>{
  int a = 0;
  @override
  void initState(){
    super.initState();
    a = a+1;
    print("TODo inint"+a.toString());
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("TODO불름?");
    return _getList();
  }
  bool isSwitched = false;
  final assignments = ["과제1", "과제2"];
  final isSwitches = [false,false];

  Widget _getList() {
    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              print(index);
              print(this.toString());
              print(isSwitches.toString());
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
            assignments[index] +"진행",
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
      onChanged: (bool newValue){
        print(newValue);
        setState(() {
          isSwitches[index] = newValue;
          print(isSwitches.toString());
        });

      },
      value: isSwitches[index],
    );
  }

}