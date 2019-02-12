package com.ryulth.klashelper.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public interface CommentService {
    ObjectMapper mapper = new ObjectMapper();
    String writeComment(String payload,Long postId) throws IOException;
}
