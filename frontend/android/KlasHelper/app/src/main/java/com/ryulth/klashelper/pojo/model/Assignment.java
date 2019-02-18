package com.ryulth.klashelper.pojo.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.RequiredArgsConstructor;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@Builder
@RequiredArgsConstructor // Jackson will deserialize using this and then invoking setter
@AllArgsConstructor(onConstructor = @__(@JsonIgnore)) // Lombok builder use this
@EqualsAndHashCode(of = {"workCode","workFile","workTitle"})
public class Assignment implements Serializable {
    private String workCode; // 고유 키
    private String semester; //year_학기  10 1학기,15 여름학기,20 2학기,25겨울학기
    private String workFile;
    private String workCourse;
    private int isSubmit; //1 제출띠
    private String workType; //(0=과제 1=인강 2=강의자료) workType int
    private String workTitle;
    private String workCreateTime;
    private String workFinishTime;
    @JsonIgnore
    private int isAlarm ;
    @JsonIgnore
    private int flag ;
}
