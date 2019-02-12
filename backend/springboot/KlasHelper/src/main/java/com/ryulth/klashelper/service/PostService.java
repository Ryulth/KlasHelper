package com.ryulth.klashelper.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

@Service
public interface PostService {
    ObjectMapper mapper = new ObjectMapper();
    String getPost(Long postId) throws JsonProcessingException;
}
