package com.ryulth.klashelper.pojo.Request;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
public class PostDataRequest {
    private String semesterCode;
    private String classCode;
    private String authorId;
    private String title;
    private String content;
}
