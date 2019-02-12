package com.ryulth.klashelper.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ryulth.klashelper.pojo.Response.PostDetailResponse;
import com.ryulth.klashelper.pojo.Response.PostListResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public interface PostService {
    ObjectMapper mapper = new ObjectMapper();
    ResponseEntity<PostListResponse> getPosts(String semesterCode, String classCode) throws JsonProcessingException;
    ResponseEntity<PostDetailResponse> getPostDetail(Long postId) throws JsonProcessingException;
    String writePost(String payload) throws IOException;
}
