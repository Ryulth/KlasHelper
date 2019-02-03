package com.example.ryulth.klashelper.pojo.model;

import android.content.Intent;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@Builder
@RequiredArgsConstructor // Jackson will deserialize using this and then invoking setter
@AllArgsConstructor(onConstructor = @__(@JsonIgnore)) // Lombok builder use this
public class Assignment {
    private String workFile;
    private String workCreateTime;
    private String workCourse;
    private String workFinishTime;
    private String workCode;
    private int isSubmit; //1 제출띠
    private String workType; //(0=과제 1=인강 2=강의자료) workType int
    private String workTitle;
}
