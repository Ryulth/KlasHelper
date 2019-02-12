package com.ryulth.klashelper.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ryulth.klashelper.pojo.Response.PostDetailResponse;
import com.ryulth.klashelper.pojo.Response.PostListResponse;
import com.ryulth.klashelper.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
public class PostController {
    @Value("${klashelper.app.token}")
    private String klashelperToken;

    @Autowired
    PostService postService;

    @GetMapping("/posts/{semesterCode}/{classCode}")
    public ResponseEntity<PostListResponse> getPosts(
            @RequestHeader("appToken") final String appToken,
            @PathVariable("semesterCode") String semesterCode,
            @PathVariable("classCode") String classCode) throws JsonProcessingException {
        if (klashelperToken.equals(appToken)) {
            return postService.getPosts(semesterCode, classCode);
        }
        return null;
    }

    @GetMapping("/post/{postId}")
    public ResponseEntity<PostDetailResponse> getPostDetail(
            @RequestHeader("appToken") final String appToken,
            @PathVariable("postId") Long postId) throws JsonProcessingException {
        if (klashelperToken.equals(appToken)) {
            return postService.getPostDetail(postId);
        }
        return null;
    }

    @PostMapping("/post")
    public String writePost(
            @RequestHeader("appToken") final String appToken,
            @RequestBody String payload) throws IOException {
        if (klashelperToken.equals(appToken)) {
            return postService.writePost(payload);
        }
        return null;
    }

}
