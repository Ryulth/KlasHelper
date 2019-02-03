package com.example.ryulth.klashelper.activity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Toast;

import com.example.ryulth.klashelper.R;
import com.example.ryulth.klashelper.api.LoginApi;
import com.example.ryulth.klashelper.model.User;


public class LoginActivity extends AppCompatActivity {

    private User user;
    private TextInputLayout inputId;
    private TextInputLayout inputPw;
    private Button buttonLogin;
    private CheckBox checkBoxRemember;
    private Boolean isLogin;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        inputId = (TextInputLayout)findViewById(R.id.inputLayoutId);
        inputPw = (TextInputLayout)findViewById(R.id.inputLayoutPw);
        buttonLogin = (Button)findViewById(R.id.buttonLogin);
        checkBoxRemember = (CheckBox)findViewById(R.id.checkBoxRember);

        buttonLogin.setOnClickListener(
                new Button.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        setUser();
                        LoginApi loginApi = new LoginApi();
                        try {
                            isLogin = loginApi.execute(user).get();
                        } catch (Exception e) {
                            Log.e(e.getMessage(), e.getStackTrace().toString());
                            isLogin=false;
                        }
                        if (isLogin){
                            saveUser();
                            Toast.makeText(getApplicationContext(),"로그인 성공",Toast.LENGTH_SHORT).show();
                            Intent intent = new Intent(getApplicationContext(),AssignmentActivity.class);
                            intent.putExtra("userInfoIntent",user);
                            startActivity(intent);
                        }
                        else {
                            Toast.makeText(getApplicationContext(),"로그인 실패",Toast.LENGTH_SHORT).show();
                        }
                    }
                }
        );
    }
    private void setUser(){
        String id = inputId.getEditText()
                .getText().toString();
        String pw = inputPw.getEditText()
                .getText().toString();
        user = User.builder()
                .id(id)
                .pw(pw).build();
    }
    private void saveUser(){
        SharedPreferences userInfoFile = getSharedPreferences("userInfoFile", MODE_PRIVATE);
        SharedPreferences.Editor editor = userInfoFile.edit();
        editor.putString("id",user.getId());
        editor.putString("pw",user.getPw());
        editor.putBoolean("isRemember",checkBoxRemember.isChecked());
        editor.commit();
    }

}
