import 'package:flutter/material.dart';
import 'assignmentTodo.dart';
import 'assignmentComplete.dart';
import 'assignmentLate.dart';
import 'assignment.dart';

abstract class AssignmentFactory extends AssignmentPageState {
  AssignmentFactory.create();

  // ignore: missing_return
  factory AssignmentFactory(AssignmentType type) {
    switch (type) {
      case AssignmentType.TODO:
        return AssignmentTodo();
      case AssignmentType.COMPLETE:
        return AssignmentComplete();
      case AssignmentType.LATE:
        return AssignmentLate();
    }
  }
  Widget getList();
}

enum AssignmentType {
  //@arg position = 0: 진행 1: 완료 2: 지난
  TODO,
  COMPLETE,
  LATE
}
