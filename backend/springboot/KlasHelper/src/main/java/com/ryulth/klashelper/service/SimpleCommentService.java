package com.ryulth.klashelper.service;

import com.ryulth.klashelper.dto.Comment;
import com.ryulth.klashelper.pojo.Request.CommentDataRequest;
import com.ryulth.klashelper.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

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
}
