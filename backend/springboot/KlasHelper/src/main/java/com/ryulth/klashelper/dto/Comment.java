package com.ryulth.klashelper.dto;

import lombok.Builder;
import lombok.Data;

import javax.persistence.*;
import java.util.Calendar;

@Entity
@Data
@Table(name = "testComment")
public class Comment {
    @Id
    @GeneratedValue
    private Long id;

    @Column(nullable = false)
    private Long postId;

    @Column(nullable = false)
    private String authorId;

    @Lob
    @Column(nullable = true)
    private String content;

    @Column(name = "createTime", nullable = false, updatable = false)
    private Calendar createTime;

    @Column(name = "updateTime")
    private Calendar updateTime;

    @Column(columnDefinition="TINYINT(1)")
    private int flag = 1;

    private Comment(){
    }
}
