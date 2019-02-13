package com.ryulth.klashelper.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ryulth.klashelper.dto.Comment;
import com.ryulth.klashelper.pojo.Request.CommentDataRequest;
import com.ryulth.klashelper.pojo.Response.CommentDetailResponse;
import com.ryulth.klashelper.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Calendar;

@Component
public class SimpleCommentService implements CommentService {
    @Autowired
    CommentRepository commentRepository;

    @Override
    public String writeComment(String payload, Long postId) throws IOException {
        CommentDataRequest commentDataRequest = mapper.readValue(payload, CommentDataRequest.class);
        commentRepository.save(Comment.builder()
                .postId(postId)
                .authorId(commentDataRequest.getAuthorId())
                .content(commentDataRequest.getContent())
                .build());
        return payload;
    }

    @Override
    public ResponseEntity<CommentDetailResponse> getCommentOne(Long commentId) throws JsonProcessingException {
        Comment comment = commentRepository.findById(commentId).orElse(null);
        Boolean isLive = (comment.getFlag() == 1);
        if (isLive) {
            CommentDetailResponse commentDetailResponse = CommentDetailResponse.builder()
                    .comment(comment).build();
            HttpHeaders headers = new HttpHeaders(); // response Header
            headers.setContentType(MediaType.APPLICATION_JSON_UTF8); // header need UTF8
            return new ResponseEntity<CommentDetailResponse>(commentDetailResponse, headers, HttpStatus.OK);
        }
        return null;
    }

    @Override
    public String updateComment(Long commentId, String payload) throws IOException {
        Comment comment = commentRepository.findById(commentId).orElse(null);
        CommentDataRequest commentDataRequest = mapper.readValue(payload, CommentDataRequest.class);
        Boolean isCommentInPost = comment.getPostId().equals(commentDataRequest.getPostId());
        if (isCommentInPost){
            comment.setAuthorId(commentDataRequest.getAuthorId());
            comment.setContent(commentDataRequest.getContent());
            comment.setPostId(commentDataRequest.getPostId());
            comment.setUpdateTime(Calendar.getInstance());
            commentRepository.save(comment);
            return payload;
        }
        return null;

    }

    @Override
    public String deleteComment(Long commentId) throws IOException {
        Comment comment = commentRepository.findById(commentId).orElse(null);
        comment.setFlag(0);
        commentRepository.save(comment);
        return "delete";
    }

}

