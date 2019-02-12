package com.ryulth.klashelper.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ryulth.klashelper.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PostController {
    @Autowired
    PostService postService;
    @GetMapping("/post/{postId}")
    public String getPosts(@PathVariable("postId") Long postId) throws JsonProcessingException {
        return postService.getPost(postId);
    }
}
