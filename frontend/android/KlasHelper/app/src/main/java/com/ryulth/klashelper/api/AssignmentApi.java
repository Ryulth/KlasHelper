package com.ryulth.klashelper.api;

import android.os.AsyncTask;
import android.util.Log;

import com.ryulth.klashelper.pojo.model.Assignment;
import com.ryulth.klashelper.pojo.request.AssignmentRequest;
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

public class AssignmentApi extends AsyncTask<AssignmentRequest, Void, List<Assignment>> {
    static  final private String getAssUrl = ApiType.ASSIGNMENT.getUrl();
    @Override
    protected List<Assignment> doInBackground(AssignmentRequest... assignmentRequests) {
        List<Assignment> assignments=null;
        try {
            assignments= getAssignments(assignmentRequests[0]);
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

    private List<Assignment> getAssignments(AssignmentRequest assignmentRequests) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        HttpHeaders headers = new HttpHeaders(); // response Header
        headers.setContentType(MediaType.APPLICATION_JSON); // header need UTF8
        String responseBody = mapper.writeValueAsString(assignmentRequests);
        HttpEntity requestEntity = new HttpEntity(responseBody, headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<UpdateResponse > responseEntity = restTemplate.postForEntity(getAssUrl, requestEntity, UpdateResponse.class);
        return responseEntity.getBody().getAssignments();
    }
}
