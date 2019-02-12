package com.ryulth.klashelper.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import javax.persistence.*;
import java.util.Calendar;

@Entity
@Data
@Builder
@AllArgsConstructor(onConstructor = @__(@JsonIgnore)) // Lombok builder use this
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
    private int flag ;

    @PrePersist// 새로운 것이 추가되었다. !!!
    void setUp() {
        this.flag = 1;
        this.createTime = Calendar.getInstance();
    }
    private Comment(){
    }
}
