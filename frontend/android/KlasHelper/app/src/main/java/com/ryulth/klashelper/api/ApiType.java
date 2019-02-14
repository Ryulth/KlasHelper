package com.ryulth.klashelper.api;

import java.util.Arrays;

public enum ApiType {

    ASSIGNMENT("assignments"),
    LOGIN("login"),
    SEMESTER("semesters");

    private static final String BASIC_URL = "http://klashelper.ryulth.com/";
    private final String subUrl;

    ApiType(String subUrl) {
        this.subUrl = subUrl;
    }

    @Override
    public String toString() {
        return this.name();
    }


    public String getUrl() {
        return BASIC_URL+this.subUrl;
    }

}
