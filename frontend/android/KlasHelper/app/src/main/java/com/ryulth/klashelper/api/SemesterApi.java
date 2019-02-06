package com.ryulth.klashelper.api;

import android.os.AsyncTask;
import android.util.Log;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ryulth.klashelper.model.User;
import com.ryulth.klashelper.pojo.response.SemesterResponse;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

public class SemesterApi extends AsyncTask<User, Void, String> {
    static  final private String semestersUrl = "http://Ryulth.com:11111/get_semesters/";
    @Override
    protected String doInBackground(User... users) {
        String semesters = "";
        try {
            semesters = getSemester(users[0]);
        } catch (JsonProcessingException e) {
            Log.e(e.getMessage(),e.getStackTrace().toString());
        }
        return semesters;
    }

    @Override
    protected void onProgressUpdate(Void... voids) {

    }

    @Override
    protected void onPostExecute(String isAuth) {
        super.onPostExecute(isAuth);
    }

    private String  getSemester(User user) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        HttpHeaders headers = new HttpHeaders(); // response Header
        headers.setContentType(MediaType.APPLICATION_JSON); // header need UTF8
        String responseBody = mapper.writeValueAsString(user);
        HttpEntity requestEntity = new HttpEntity(responseBody, headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<SemesterResponse> responseEntity = restTemplate.postForEntity(semestersUrl, requestEntity, SemesterResponse.class);
        return responseEntity.getBody().getSemesters();
    }
}
