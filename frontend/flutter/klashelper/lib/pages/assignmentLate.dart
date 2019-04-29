import 'package:flutter/material.dart';
import 'package:klashelper/models/workType.dart';
import 'package:klashelper/pages/assignmentFactory.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:klashelper/dao/assignmentDao.dart';

// ignore: must_be_immutable
class AssignmentLate extends AssignmentFactory {
  AssignmentLate() : super.create();

  List<Assignment> _assignments = [];
  WorkType _workType;

  @override
  void setWorkType(WorkType workType) {
    this._workType = workType;
  }

  @override
  void setAssignments(List<Assignment> assignments) {
    this._assignments = assignments;
  }

  @override
  AssignmentLateState createState() => AssignmentLateState();

  @override
  List<Assignment> getAssignments() {
    // TODO: implement getAssignments
    return _assignments;
  }
}

class AssignmentLateState extends State<AssignmentLate>
    with AutomaticKeepAliveClientMixin<AssignmentLate> {
  AssignmentDao _assignmentDao = new AssignmentDao();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    String tableName = "assignment_" + "2013104068";
    _assignmentDao.setDatabase(tableName);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  ListView.builder(
      itemCount: widget._assignments.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              print(index);
              print(widget._assignments[index].toJson().toString());
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
            widget._assignments[index].workCourse,
            style: TextStyle(fontSize: 10),
          ),
          Text(
            widget._assignments[index].workTitle,
            style: TextStyle(fontSize: 16),
          ),
          Text.rich(TextSpan(
              text: widget._assignments[index].workFinishTime,
              children: <TextSpan>[_isComplete(index)])),
        ],
      ),
    );
    return column;
  }

  
  TextSpan _isComplete(int index) {
    if(widget._workType == WorkType.HOMEWORK){
      if (widget._assignments[index].isSubmit == 1) {
        return TextSpan(
            text: " 제출",
            style: TextStyle(
              color: Colors.green, textBaseline: TextBaseline.ideographic
            ));
      } else {
        return TextSpan(
            text: " 미제출",
            style: TextStyle(
              color: Colors.red,
            ));
      }
    }
    else if(widget._workType == WorkType.ONLINE){
      if (widget._assignments[index].isSubmit == 1) {
        return TextSpan(
            text: " 수강완료",
            style: TextStyle(
              color: Colors.green,
            ));
      } else {
        return TextSpan(
            text: " 미수강",
            style: TextStyle(
              color: Colors.red,
            ));
      }
    }
    else{
      return TextSpan(
            text: "",
            style: TextStyle(
              color: Colors.red,
            ));
      }
  }

  Switch _getSwitch(int index) {
    return Switch(
      activeColor: Color(0xFFA40F16),
      onChanged: (bool newValue) {
        setState(() {
          int isAlarm = (newValue) ? 1 : 0;
          widget._assignments[index].isAlarm = isAlarm;
          _assignmentDao.updateAssignment(widget._assignments[index]);
        });
      },
      value: (widget._assignments[index].isAlarm == 1) ? true : false,
    );
  }
}
