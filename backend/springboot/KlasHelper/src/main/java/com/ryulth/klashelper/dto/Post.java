package com.ryulth.klashelper.dto;

import lombok.Builder;
import lombok.Data;

import javax.persistence.*;
import java.util.Calendar;

@Entity
@Data
@Table(name = "testPost")
public class Post {
    @Id
    @GeneratedValue
    private Long id;

    @Column(nullable = false)
    private String semesterCode;

    @Column(nullable = false)
    private String classCode;

    @Column(nullable = false)
    private String authorId;

    @Lob
    @Column(nullable = true)
    private String title;

    @Lob
    @Column(nullable = true)
    private String content;

    @Column(name = "createTime", nullable = false, updatable = false)
    private Calendar createTime;

    @Column(name = "updateTime")
    private Calendar updateTime;

    @Column
    private int hit = 0;

    @Column(columnDefinition="TINYINT(1)")
    private int flag = 1;

    private Post(){
    }
}
