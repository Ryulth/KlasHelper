package com.ryulth.klashelper.api;

import android.os.AsyncTask;
import android.util.Log;

import com.ryulth.klashelper.model.User;
import com.ryulth.klashelper.pojo.model.Assignment;
import com.ryulth.klashelper.pojo.response.LoginResponse;
import com.ryulth.klashelper.pojo.response.UpdateResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.List;

public class AssignmentApi extends AsyncTask<User, Void, List<Assignment>> {
    static  final private String getAssUrl = "http://Ryulth.com:11111/get_ass/";
    @Override
    protected List<Assignment> doInBackground(User... users) {
        List<Assignment> assignments=null;
        try {
            assignments= getAssignments(users[0]);
        } catch (JsonProcessingException e) {
            Log.e(e.getMessage(),e.getStackTrace().toString());
        }
        return assignments;
    }

    @Override
    protected void onProgressUpdate(Void... voids) {
    }

    @Override
    protected void onPostExecute(List<Assignment> assignments) {
        super.onPostExecute(assignments);
    }

    private List<Assignment> getAssignments(User user) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        HttpHeaders headers = new HttpHeaders(); // response Header
        headers.setContentType(MediaType.APPLICATION_JSON); // header need UTF8
        String responseBody = mapper.writeValueAsString(user);
        HttpEntity requestEntity = new HttpEntity(responseBody, headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<UpdateResponse > responseEntity = restTemplate.postForEntity(getAssUrl, requestEntity, UpdateResponse.class);
        return responseEntity.getBody().getAssignments();
    }
}
