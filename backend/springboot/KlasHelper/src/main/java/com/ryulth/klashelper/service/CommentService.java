package com.ryulth.klashelper.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ryulth.klashelper.pojo.Response.CommentDetailResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public interface CommentService {
    ObjectMapper mapper = new ObjectMapper();
    String writeComment(String payload,Long postId) throws IOException;
    ResponseEntity<CommentDetailResponse> getCommentOne(Long commentId) throws JsonProcessingException;
    String updateComment(Long commentId, String payload) throws IOException;
    String deleteComment(Long commentId) throws IOException;
}

