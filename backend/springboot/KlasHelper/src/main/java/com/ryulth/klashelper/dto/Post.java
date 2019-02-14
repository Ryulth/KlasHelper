package com.ryulth.klashelper.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Calendar;

@Entity
@Data
@Builder
@AllArgsConstructor(onConstructor = @__(@JsonIgnore)) // Lombok builder use this
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
    private int hit;

    @Column(columnDefinition = "TINYINT(1)")
    private int flag;

    @PrePersist// 새로운 것이 추가되었다. !!!
    void setUp() {
        this.hit = 0;
        this.flag = 1;
        this.createTime = Calendar.getInstance();
    }
    private Post() {
    }
}
