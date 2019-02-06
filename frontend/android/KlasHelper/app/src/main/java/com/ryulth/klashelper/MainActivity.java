package com.ryulth.klashelper;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.Toast;

import com.ryulth.klashelper.activity.AssignmentActivity;
import com.ryulth.klashelper.activity.LoginActivity;
import com.ryulth.klashelper.api.LoginApi;
import com.ryulth.klashelper.model.User;

public class MainActivity extends AppCompatActivity {
    private Intent intent;
    private Boolean isLogin;
    private User user;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        autoLogin();
    }
    @Override
    protected void onResume(){
        super.onResume();
        autoLogin();
    }

    private void autoLogin(){
        if (isRememberUser()) {
            LoginApi loginApi = new LoginApi();
            try {
                isLogin = loginApi.execute(user).get();
            } catch (Exception e) {
                isLogin = false;
            }
            if (isLogin) {
                Toast.makeText(getApplicationContext(),"자동 로그인 성공",Toast.LENGTH_SHORT).show();
                intent = new Intent(getApplicationContext(), AssignmentActivity.class);
                intent.putExtra("userInfoIntent",user);
            }
            else {
                Toast.makeText(getApplicationContext(),"자동 로그인 실패",Toast.LENGTH_SHORT).show();
                intent = new Intent(getApplicationContext(), LoginActivity.class);
            }
        } else {
            intent = new Intent(getApplicationContext(), LoginActivity.class);
        }
        startActivity(intent);
    }
    private Boolean isRememberUser() {
        SharedPreferences userInfoFile = getSharedPreferences("userInfoFile", MODE_PRIVATE);
        Boolean isRemember = userInfoFile.getBoolean("isRemember",false);
        if (isRemember){
            user = User.builder()
                    .id(userInfoFile.getString("id",""))
                    .pw(userInfoFile.getString("pw",""))
                    .build();
        }
        return isRemember;

    }
}
