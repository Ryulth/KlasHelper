package com.ryulth.klashelper.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.MenuItem;
import android.widget.TextView;

import com.ryulth.klashelper.R;
import com.ryulth.klashelper.pojo.model.Assignment;



public class DetailActivity extends AppCompatActivity {
    private Toolbar toolbar;
    private Assignment assignment;
    private TextView textViewCourse;
    private TextView textViewTitle;
    private TextView textViewFile;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);
        this.toolbar = (Toolbar) findViewById(R.id.toolbarDetails);
        this.toolbar.setTitle("");
        this.setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        Intent intent = getIntent();
        this.assignment = (Assignment) intent.getSerializableExtra("assignmentIntent");
        this.textViewCourse = (TextView) findViewById(R.id.textDetailCourse);
        this.textViewTitle = (TextView) findViewById(R.id.textDetailTitle);
        this.textViewFile = (TextView) findViewById(R.id.textDetailFile);

        textViewCourse.setText(assignment.getWorkCourse());
        textViewTitle.setText(assignment.getWorkTitle());

        String[] links = assignment.getWorkFile().split("[*]]");
        if("[".equals(links[0])){
            textViewFile.setText("첨부파일 없음");
        }
        else {
            StringBuffer stringBuffer = new StringBuffer();
            textViewFile.setClickable(true);
            textViewFile.setMovementMethod(LinkMovementMethod.getInstance());
            stringBuffer.append("<a href='");
            stringBuffer.append(links[1]);
            stringBuffer.append("'> ");
            stringBuffer.append(links[0].replace("[",""));
            stringBuffer.append(" </a>");
            textViewFile.setText(Html.fromHtml(stringBuffer.toString()));
        }

    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case android.R.id.home:{ //toolbar의 back키 눌렀을 때 동작
                finish();
                return true;
            }
        }
        return super.onOptionsItemSelected(item);
    }
}
