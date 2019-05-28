import 'package:flutter/material.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:klashelper/models/user.dart';
import 'package:klashelper/pages/assignmentTodo.dart';
import 'package:klashelper/pages/assignmentComplete.dart';
import 'package:klashelper/pages/assignmentLate.dart';
import 'assignmentType.dart';
import 'package:klashelper/models/workType.dart';

abstract class AssignmentFactory extends StatefulWidget {
  AssignmentFactory.create();
  
  // ignore: missing_return
  factory AssignmentFactory(AssignmentType _assignmentType,User _user) {
    switch (_assignmentType) {
      case AssignmentType.TODO:
        return new AssignmentTodo(user: _user);
      case AssignmentType.COMPLETE:
        return new AssignmentComplete();
      case AssignmentType.LATE:
        return new AssignmentLate(user: _user);
    }
  }

  void setWorkType(WorkType workType);

  void setAssignments(List<Assignment> assignments);
  List<Assignment> getAssignments();
}
