package com.example.ryulth.klashelper.model;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class User implements Serializable {
    private String id;
    private String pw;
}
