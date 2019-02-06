package com.ryulth.klashelper.database;

import android.app.assist.AssistStructure;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteConstraintException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.widget.Toast;

import com.ryulth.klashelper.pojo.model.Assignment;

import java.util.ArrayList;
import java.util.List;


public class AssignmentRepository extends SQLiteOpenHelper {
    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "assignmentdb";
    private Context context;

    public AssignmentRepository(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context;
    }


    @Override
    public void onCreate(SQLiteDatabase db) {
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }

    public List<Assignment> getAllAssignments(String tableName) throws SQLiteException {
        SQLiteDatabase db = getReadableDatabase();
        StringBuffer sb = new StringBuffer();
        sb.append(" SELECT workCode, semester, workFile, workCourse, isSubmit, workType, workTitle, workCreateTime, workFinishTime, flag FROM ");
        sb.append(tableName);
        Cursor cursor = db.rawQuery(sb.toString(), null);

        List<Assignment> assignments = new ArrayList<>();
        while (cursor.moveToNext()) {
            assignments.add(Assignment.builder()
                    .workCode(cursor.getString(0))
                    .semester(cursor.getString(1))
                    .workFile(cursor.getString(2))
                    .workCourse(cursor.getString(3))
                    .isSubmit(cursor.getInt(4))
                    .workType(cursor.getString(5))
                    .workTitle(cursor.getString(6))
                    .workCreateTime(cursor.getString(7))
                    .workFinishTime(cursor.getString(8))
                    .flag(cursor.getInt(9)).build());
        }
        return assignments;
    }

    public void createTable(String tableName) {
        SQLiteDatabase db = getWritableDatabase();
        StringBuffer sb = new StringBuffer();
        sb.append(" CREATE TABLE IF NOT EXISTS ");
        sb.append(tableName);
        //sb.append("(  _ID INTEGER PRIMARY KEY AUTOINCREMENT, ");
        sb.append(" ( workCode TEXT PRIMARY KEY, ");
        sb.append(" semester TEXT, ");
        sb.append(" workFile TEXT, ");
        sb.append(" workCourse TEXT, ");
        sb.append(" isSubmit INTEGER, ");
        sb.append(" workType TEXT, ");
        sb.append(" workTitle TEXT, ");
        sb.append(" workCreateTime TEXT, ");
        sb.append(" workFinishTime TEXT, ");
        sb.append("flag INTEGER )");

        db.execSQL(sb.toString());
    }

    public void insertAssignment(Assignment assignment, String tableName) throws SQLiteConstraintException {
        SQLiteDatabase db = getWritableDatabase();
        StringBuffer sb = new StringBuffer();
        sb.append(" INSERT INTO ");
        sb.append(tableName);
        sb.append("( workCode, semester, workFile, workCourse, isSubmit, workType, workTitle, workCreateTime, workFinishTime, flag) ");
        sb.append(" VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?,? ) ");

        db.execSQL(sb.toString(),
                new Object[]{assignment.getWorkCode(),
                        assignment.getSemester(),
                        assignment.getWorkFile(),
                        assignment.getWorkCourse(),
                        assignment.getIsSubmit(),
                        assignment.getWorkType(),
                        assignment.getWorkTitle(),
                        assignment.getWorkCreateTime(),
                        assignment.getWorkFinishTime(),
                        1});

    }


}
