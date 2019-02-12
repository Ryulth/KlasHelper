package com.ryulth.klashelper.controller;

import com.ryulth.klashelper.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
public class CommentController {
    @Value("${klashelper.app.token}")
    private String klashelperToken;

    @Autowired
    CommentService commentService;

    @PostMapping("/comment/{postId}")
    public String writeComment(
            @RequestHeader("appToken") final String appToken,
            @RequestBody String payload,
            @PathVariable("postId") Long postId) throws IOException {
        if (klashelperToken.equals(appToken)) {
            return commentService.writeComment(payload, postId);
        }
        return null;
    }
    @GetMapping("/login")
    public void Post(
            @RequestHeader("appToken") final String appToken,
            @RequestHeader("id") final String id,
            @RequestHeader("pw") final String pw) throws IOException {
        System.out.println(id);
        System.out.println(pw);
    }
}
