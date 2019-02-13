package com.ryulth.klashelper.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ryulth.klashelper.dto.Comment;
import com.ryulth.klashelper.dto.Post;
import com.ryulth.klashelper.pojo.Request.PostDataRequest;
import com.ryulth.klashelper.pojo.Response.PostDetailResponse;
import com.ryulth.klashelper.pojo.Response.PostListResponse;
import com.ryulth.klashelper.repository.CommentRepository;
import com.ryulth.klashelper.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;

@Component
public class SimplePostService implements PostService {
    @Autowired
    PostRepository postRepository;
    @Autowired
    CommentRepository commentRepository;

    @Override
    public ResponseEntity<PostListResponse> getPosts(String semesterCode, String classCode) throws JsonProcessingException {
        List<Post> posts = postRepository.findBySemesterCodeAndClassCode(semesterCode, classCode);
        PostListResponse postDataResponse = PostListResponse.builder()
                .posts(posts).build();

        HttpHeaders headers = new HttpHeaders(); // response Header
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8); // header need UTF8
        return new ResponseEntity<PostListResponse>(postDataResponse, headers, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<PostDetailResponse> getPostOne(Long postId) throws JsonProcessingException {
        Post post = postRepository.findById(postId).orElse(null);
        Boolean isLive = (post.getFlag() == 1);
        if (isLive) {
            List<Comment> comments = commentRepository.findByPostId(postId);
            comments.removeIf(comment -> comment.getFlag() == 0);
            PostDetailResponse postDetailResponse = PostDetailResponse.builder()
                    .post(post).comments(comments).build();
            HttpHeaders headers = new HttpHeaders(); // response Header
            headers.setContentType(MediaType.APPLICATION_JSON_UTF8); // header need UTF8
            return new ResponseEntity<PostDetailResponse>(postDetailResponse, headers, HttpStatus.OK);
        }
        return null;

    }

    @Override
    public String updatePost(Long postId, String payload) throws IOException {
        Post post = postRepository.findById(postId).orElse(null);
        PostDataRequest postUpdateRequest = mapper.readValue(payload, PostDataRequest.class);
        post.setAuthorId(postUpdateRequest.getAuthorId());
        post.setClassCode(postUpdateRequest.getClassCode());
        post.setContent(postUpdateRequest.getContent());
        post.setSemesterCode(postUpdateRequest.getSemesterCode());
        post.setTitle(postUpdateRequest.getTitle());
        post.setUpdateTime(Calendar.getInstance());
        postRepository.save(post);
        return payload;
    }

    @Override
    public String deletePost(Long postId) throws IOException {
        Post post = postRepository.findById(postId).orElse(null);
        post.setFlag(0);
        postRepository.save(post);
        return "delete";
    }

    @Override
    public String writePost(String payload) throws IOException {
        PostDataRequest postWriteRequest = mapper.readValue(payload, PostDataRequest.class);
        postRepository.save(Post.builder()
                .authorId(postWriteRequest.getAuthorId())
                .semesterCode(postWriteRequest.getSemesterCode())
                .classCode(postWriteRequest.getClassCode())
                .title(postWriteRequest.getTitle())
                .content(postWriteRequest.getContent())
                .build());
        return payload;
    }
}
