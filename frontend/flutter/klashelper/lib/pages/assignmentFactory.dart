import 'package:flutter/material.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:klashelper/pages/assignmentTodo.dart';
import 'package:klashelper/pages/assignmentComplete.dart';
import 'package:klashelper/pages/assignmentLate.dart';
import 'assignmentType.dart';
import 'package:klashelper/models/workType.dart';

abstract class AssignmentFactory extends StatefulWidget {
  AssignmentFactory.create();

  // ignore: missing_return
  factory AssignmentFactory(AssignmentType assignmentType) {
    switch (assignmentType) {
      case AssignmentType.TODO:
        return new AssignmentTodo();
      case AssignmentType.COMPLETE:
        return new AssignmentComplete();
      case AssignmentType.LATE:
        return new AssignmentLate();
    }
  }

  void setWorkType(WorkType workType);

  void setAssignments(List<Assignment> assignments);
  List<Assignment> getAssignments();
}
