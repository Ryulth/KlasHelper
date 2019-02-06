package com.ryulth.klashelper.activity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.database.sqlite.SQLiteConstraintException;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;


import com.ryulth.klashelper.MainActivity;
import com.ryulth.klashelper.R;
import com.ryulth.klashelper.adapter.AssignmentsViewAdapter;
import com.ryulth.klashelper.api.AssignmentApi;
import com.ryulth.klashelper.database.AssignmentRepository;
import com.ryulth.klashelper.model.User;
import com.ryulth.klashelper.pojo.model.Assignment;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class AssignmentActivity extends AppCompatActivity {
    private User user;
    private List<Assignment> assignments = new ArrayList<>();
    private List<Assignment> homeworks = new ArrayList<>();
    private List<Assignment> lectures = new ArrayList<>();
    private List<Assignment> notes = new ArrayList<>();
    private ListView listView;
    private SwipeRefreshLayout swipeRefreshLayout;
    private MyHandler myHandler;
    private BottomNavigationView navigation;
    private Toolbar toolbar;
    private long lastTimeBackPressed; //뒤로가기 버튼이 클릭된 시간
    private ObjectMapper mapper = new ObjectMapper();
    private AssignmentRepository assignmentRepository;
    private String tableName;
    private String semester;
    private static class MyHandler extends Handler {
        AssignmentActivity activity;

        public MyHandler(AssignmentActivity activity) {
            this.activity = activity;
        }

        @Override
        public void handleMessage(Message msg) {
            activity.mappingAssignments();

        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_assignment);
        Intent intent = getIntent();
        this.user = (User) intent.getSerializableExtra("userInfoIntent");
        this.assignmentRepository = new AssignmentRepository(getApplicationContext());
        //TODO 나중에 학기 선택 가능 하도록 변경
        this.semester = "2018_20";
        this.tableName= "a"+user.getId() + "_" +semester ;
        this.navigation = (BottomNavigationView) findViewById(R.id.navigation);
        this.myHandler = new MyHandler(this);
        this.listView = (ListView) findViewById(R.id.navigation_assignment);
        this.toolbar = (Toolbar) findViewById(R.id.toolbarAssignment);
        this.setSupportActionBar(toolbar);
        try {
            if (this.loadAssignment()) {
                this.mappingAssignments();
            }
        } catch (IOException e) {
            Log.e(e.getMessage(), e.getStackTrace().toString());
        }

        swipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_layout);
        swipeRefreshLayout.setOnRefreshListener(
                new SwipeRefreshLayout.OnRefreshListener() {
                    @Override
                    public void onRefresh() {
                        // Your code here

                        swipeRefreshLayout.setRefreshing(true);
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                getAssignments();
                                Message msg = myHandler.obtainMessage();
                                myHandler.sendMessage(msg);
                                swipeRefreshLayout.setRefreshing(false);
                            }
                        }).start();
                    }
                });

        swipeRefreshLayout.setColorSchemeColors(
                getResources().getColor(android.R.color.holo_blue_bright),
                getResources().getColor(android.R.color.holo_green_light),
                getResources().getColor(android.R.color.holo_orange_light),
                getResources().getColor(android.R.color.holo_red_light)
        );

        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater menuInflater = getMenuInflater();
        menuInflater.inflate(R.menu.menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_settings:
                Toast.makeText(getApplicationContext(), "로그아웃띠", Toast.LENGTH_LONG).show();
                logout();
                return true;

            case R.id.action_sidebar:
                Toast.makeText(getApplicationContext(), "메뉴 버튼 클릭됨", Toast.LENGTH_LONG).show();
                return true;
        }
        return true;
    }

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {
        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_assignment:
                    setHomeworks();
                    return true;
                case R.id.navigation_lecture:
                    setLectures();
                    return true;
                case R.id.navigation_notes:
                    setNotes();
                    return true;
            }
            return false;
        }
    };

    private void getAssignments() {
        AssignmentApi assignmentApi = new AssignmentApi();
        try {
            this.assignments = null;
            this.assignments = assignmentApi.execute(user).get();
            this.assignmentRepository.createTable(tableName);
            this.insertAssignment();
        } catch (Exception e) {
            Log.e(e.getMessage(), e.getStackTrace().toString());
        }
    }

    private void mappingAssignments() {
        for (Assignment assignment : assignments) {
            switch (assignment.getWorkType()) {
                case "0":
                    this.homeworks.add(assignment);
                    break;
                case "1":
                    this.lectures.add(assignment);
                    break;
                case "2":
                    this.notes.add(assignment);
                    break;
            }
        }
        switch (navigation.getSelectedItemId()) {
            case R.id.navigation_assignment:
                this.setHomeworks();
            case R.id.navigation_lecture:
                this.setLectures();
            case R.id.navigation_notes:
                this.setHomeworks();
        }
    }

    private void setHomeworks() {
        AssignmentsViewAdapter assignmentsViewAdapter = new AssignmentsViewAdapter();
        assignmentsViewAdapter.setAssignments(homeworks);
        listView.setAdapter(assignmentsViewAdapter);
    }

    private void setLectures() {
        AssignmentsViewAdapter assignmentsViewAdapter = new AssignmentsViewAdapter();
        assignmentsViewAdapter.setAssignments(lectures);
        listView.setAdapter(assignmentsViewAdapter);
    }

    private void setNotes() {
        AssignmentsViewAdapter assignmentsViewAdapter = new AssignmentsViewAdapter();
        assignmentsViewAdapter.setAssignments(notes);
        listView.setAdapter(assignmentsViewAdapter);
    }

    private void logout() {
        SharedPreferences userInfoFile = getSharedPreferences("userInfoFile", MODE_PRIVATE);
        SharedPreferences.Editor editor = userInfoFile.edit();
        editor.putBoolean("isRemember", false);
        editor.commit();
        Intent intentHome = new Intent(this, MainActivity.class);
        intentHome.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intentHome.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intentHome);
    }

    @Override
    public void onBackPressed() {
        //2초 이내에 뒤로가기 버튼을 재 클릭 시 앱 종료
        if (System.currentTimeMillis() - lastTimeBackPressed < 2000) {
            this.finishAffinity();
            return;
        }
        //'뒤로' 버튼 한번 클릭 시 메시지
        Toast.makeText(this, "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.", Toast.LENGTH_SHORT).show();
        lastTimeBackPressed = System.currentTimeMillis();
    }


    private Boolean loadAssignment() throws IOException {
        try {
            assignments = assignmentRepository.getAllAssignments(tableName);
        }catch (SQLiteException e ){
            return false;
        }
        if (assignments.isEmpty()){
            return false;
        }
        return true;
    }

    private void insertAssignment() {
        for (Assignment assignment : assignments) {
            try {
                assignmentRepository.insertAssignment(assignment,tableName);
            }
            catch (SQLiteConstraintException e){
            }
        }
    }
}
