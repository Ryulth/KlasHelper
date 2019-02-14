package com.ryulth.klashelper.api;

import android.os.AsyncTask;
import android.util.Log;

import com.ryulth.klashelper.model.User;
import com.ryulth.klashelper.pojo.response.LoginResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

public class LoginApi  extends AsyncTask<User, Void, Boolean> {
    static  final private String loginUrl = ApiType.LOGIN.getUrl();
    @Override
    protected Boolean doInBackground(User... users) {
        Boolean isAuth = false;
        try {
            isAuth = isLogin(users[0]);
        } catch (JsonProcessingException e) {
            Log.e(e.getMessage(),e.getStackTrace().toString());
        }
        return isAuth;
    }

    @Override
    protected void onProgressUpdate(Void... voids) {

    }

    @Override
    protected void onPostExecute(Boolean isAuth) {
        super.onPostExecute(isAuth);
    }

    private boolean isLogin(User user) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        HttpHeaders headers = new HttpHeaders(); // response Header
        headers.setContentType(MediaType.APPLICATION_JSON); // header need UTF8
        headers.set("appToken","test");
        String responseBody = mapper.writeValueAsString(user);
        HttpEntity requestEntity = new HttpEntity(responseBody, headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<LoginResponse> responseEntity = restTemplate.postForEntity(loginUrl, requestEntity, LoginResponse.class);
        return responseEntity.getBody().getFlag();
    }

}
