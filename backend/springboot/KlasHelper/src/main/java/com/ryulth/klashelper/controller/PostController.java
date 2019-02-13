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

    /*
     * 게시글 작성
     */
    @PostMapping("/post")
    public String writePost(
            @RequestHeader("appToken") final String appToken,
            @RequestBody String payload) throws IOException {
        if (klashelperToken.equals(appToken)) {
            return postService.writePost(payload);
        }
        return null;
    }

    /*
     * 게시글 리스트
     */
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

    /*
     * 게시글 상세 정보
     */
    @GetMapping("/posts/{postId}")
    public ResponseEntity<PostDetailResponse> getPostOne(
            @RequestHeader("appToken") final String appToken,
            @PathVariable("postId") Long postId) throws JsonProcessingException {
        if (klashelperToken.equals(appToken)) {
            return postService.getPostOne(postId);
        }
        return null;
    }

    /*
     * 게시글 수정
     */
    @PutMapping("/posts/{postId}")
    public String updatePost(
            @RequestHeader("appToken") final String appToken,
            @PathVariable("postId") Long postId,
            @RequestBody String payload) throws IOException {
        if (klashelperToken.equals(appToken)) {
            return postService.updatePost(postId, payload);
        }
        return null;
    }

    /*
     * 게시글 삭제
     */
    @DeleteMapping("/posts/{postId}")
    public String deletePost(
            @RequestHeader("appToken") final String appToken,
            @PathVariable("postId") Long postId) throws IOException {
        if (klashelperToken.equals(appToken)) {
            return postService.deletePost(postId);
        }
        return null;
    }


}
