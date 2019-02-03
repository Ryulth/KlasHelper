package com.example.ryulth.klashelper.activity;

import android.content.Intent;
import android.content.SharedPreferences;
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


import com.example.ryulth.klashelper.MainActivity;
import com.example.ryulth.klashelper.R;
import com.example.ryulth.klashelper.adapter.AssignmentsViewAdapter;
import com.example.ryulth.klashelper.api.AssignmentApi;
import com.example.ryulth.klashelper.model.User;
import com.example.ryulth.klashelper.pojo.model.Assignment;

import java.util.ArrayList;
import java.util.List;


public class AssignmentActivity extends AppCompatActivity {
    private User user;
    private List<Assignment> assignments = new ArrayList<>();
    private List<Assignment> homeworks = new ArrayList<>();
    private List<Assignment> lectures = new ArrayList<>();
    private List<Assignment> notes = new ArrayList<>();
    private ListView listView;
    private TextView mTextMessage;
    private SwipeRefreshLayout swipeRefreshLayout;
    private MyHandler myHandler;
    private BottomNavigationView navigation;
    private Toolbar toolbar;

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
        user = (User) intent.getSerializableExtra("userInfoIntent");
        mTextMessage = (TextView) findViewById(R.id.message);
        navigation = (BottomNavigationView) findViewById(R.id.navigation);
        myHandler = new MyHandler(this);
        listView = (ListView) findViewById(R.id.navigation_assignment);
        toolbar = (Toolbar) findViewById(R.id.toolbarAssignment);
        setSupportActionBar(toolbar);

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
        //return super.onOptionsItemSelected(item);
        switch (item.getItemId()) {
            case R.id.action_settings:
                // User chose the "Settings" item, show the app settings UI...
                Toast.makeText(getApplicationContext(), "로그아웃띠", Toast.LENGTH_LONG).show();
                logout();
                return true;

            case R.id.action_sidebar:
                // If we got here, the user's action was not recognized.
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
            assignments = null;
            assignments = assignmentApi.execute(user).get();
        } catch (Exception e) {
            Log.e(e.getMessage(), e.getStackTrace().toString());
        }
    }

    private void mappingAssignments() {
        for (Assignment assignment : assignments) {
            switch (assignment.getWorkType()) {
                case "0":
                    homeworks.add(assignment);
                    break;
                case "1":
                    lectures.add(assignment);
                    break;
                case "2":
                    notes.add(assignment);
                    break;
            }
        }
        switch (navigation.getSelectedItemId()) {
            case R.id.navigation_assignment:
                setHomeworks();
            case R.id.navigation_lecture:
                setLectures();
            case R.id.navigation_notes:
                setHomeworks();
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

}
