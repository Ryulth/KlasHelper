package com.ryulth.klashelper.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ryulth.klashelper.dto.Post;
import com.ryulth.klashelper.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class SimplePostService implements PostService {
    @Autowired
    PostRepository postRepository;
    @Override
    public String getPost(Long postId) throws JsonProcessingException {
        Optional<Post> post = postRepository.findById(postId);
        mapper.writeValueAsString(post.get());
        return null;
    }
}
