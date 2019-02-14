package com.ryulth.klashelper.pojo.Request;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
public class CommentDataRequest {
    private Long postId;
    private String authorId;
    private String content;
}