package com.ryulth.klashelper.service;

import com.ryulth.klashelper.model.User;
import com.ryulth.klashelper.pojo.model.Assignment;

import java.util.List;

public interface AssignmentService {
    List<Assignment> getAssignment(String selectSemester, User user);
    List<Assignment> loadAssignment(String tableName);
    String getSemesters(User user);

}
