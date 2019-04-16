import 'package:flutter/material.dart';
import 'package:klashelper/pages/assignmentTodo.dart';
import 'package:klashelper/pages/assignmentComplete.dart';
import 'package:klashelper/pages/assignmentLate.dart';

abstract class AssignmentFactory extends StatefulWidget {
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
}

enum AssignmentType {
  //@arg position = 0: 진행 1: 완료 2: 지난
  TODO,
  COMPLETE,
  LATE
}
