package com.ryulth.klashelper.activity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Message;
import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Toast;

import com.ryulth.klashelper.R;
import com.ryulth.klashelper.api.LoginApi;
import com.ryulth.klashelper.model.User;


public class LoginActivity extends AppCompatActivity {

    private User user;
    private TextInputLayout inputId;
    private TextInputLayout inputPw;
    private Button buttonLogin;
    private CheckBox checkBoxRemember;
    private Boolean isLogin;
    private ProgressDialog dialog;
    private MyHandler myHandler;
    private static class MyHandler extends Handler {
        LoginActivity activity;

        public MyHandler(LoginActivity activity) {
            this.activity = activity;
        }

        @Override
        public void handleMessage(Message msg) {
            if (activity.isLogin){
                activity.saveUser();
                Toast.makeText(activity.getApplicationContext(),"로그인 성공",Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(activity.getApplicationContext(),AssignmentActivity.class);
                intent.putExtra("userInfoIntent",activity.user);
                activity.startActivity(intent);
            }
            else {
                Toast.makeText(activity.getApplicationContext(),"로그인 실패",Toast.LENGTH_SHORT).show();
            }
            activity.dialog.dismiss();
        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        inputId = (TextInputLayout)findViewById(R.id.inputLayoutId);
        /* TODO 할지 말지 고민
        SharedPreferences userInfoFile = getSharedPreferences("userInfoFile", MODE_PRIVATE);
        String oldId = userInfoFile.getString("id","");
        */
        inputPw = (TextInputLayout)findViewById(R.id.inputLayoutPw);
        buttonLogin = (Button)findViewById(R.id.buttonLogin);
        checkBoxRemember = (CheckBox)findViewById(R.id.checkBoxRember);
        this.myHandler = new MyHandler(this);
        buttonLogin.setOnClickListener(
                new Button.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        showProgressDialog();
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                doLogin();
                                Message msg = myHandler.obtainMessage();
                                myHandler.sendMessage(msg);
                            }
                        }).start();
                    }
                }
        );
    }
    private void doLogin(){
        setUser();
        LoginApi loginApi = new LoginApi();
        try {
            isLogin = loginApi.execute(user).get();
        } catch (Exception e) {
            Log.e(e.getMessage(), e.getStackTrace().toString());
            isLogin=false;
        }
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
    private void showProgressDialog() {
        dialog = new ProgressDialog(this);
        dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        dialog.setMessage("최초 로그인이시면 잠시만 기다려 주세요.");
        dialog.show();
    }

}
