package com.ryulth.klashelper.service;

import android.content.Context;
import android.database.sqlite.SQLiteException;

import com.ryulth.klashelper.api.AssignmentApi;
import com.ryulth.klashelper.api.SemesterApi;
import com.ryulth.klashelper.database.AssignmentRepository;
import com.ryulth.klashelper.model.User;
import com.ryulth.klashelper.pojo.model.Assignment;
import com.ryulth.klashelper.pojo.request.AssignmentRequest;

import java.util.ArrayList;
import java.util.List;

public class SimpleAssignmentService implements AssignmentService {
    private Context context;
    private AssignmentRepository assignmentRepository;
    public SimpleAssignmentService(Context getApplicationContext) {
        this.context = getApplicationContext;
        this.assignmentRepository = new AssignmentRepository(this.context);
    }

    @Override
    public List<Assignment> getAssignment(String selectSemester, User user) {
        List<Assignment> assignments = new ArrayList<>();
        AssignmentApi assignmentApi = new AssignmentApi();
        String tableName = "a" + user.getId() + "_" + selectSemester;
        assignments.clear();
        try {
            assignments = assignmentApi.execute(
                    AssignmentRequest.builder()
                            .id(user.getId())
                            .pw(user.getPw())
                            .semester(selectSemester)
                            .build()).get();
            this.assignmentRepository.createTable(tableName);
            this.assignmentRepository.insertAssignments(assignments, tableName);
            assignments = this.loadAssignment(tableName);
        } catch (Exception ignore) {
        }
        return assignments;
    }

    @Override
    public List<Assignment> loadAssignment(String tableName) {
        List<Assignment> assignments = new ArrayList<>();
        try {
            assignments = assignmentRepository.getAllAssignments(tableName);
        } catch (SQLiteException ignore) {
        }
        return assignments;
    }

    @Override
    public String getSemesters(User user) {
        SemesterApi semesterApi = new SemesterApi();
        String semesters;
        try {
            semesters = semesterApi.execute(user).get();
        } catch (Exception ignore) {
            semesters = null;
        }
        return semesters;
    }

}
