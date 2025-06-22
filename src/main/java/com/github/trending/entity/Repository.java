package com.github.trending.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Table(name = "repositories")
public class Repository {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String owner;

    @Column(length = 1000)
    private String description;

    private Integer stars;

    private Integer forks;

    private String language;

    @Column(nullable = false)
    private String url;

    @Column(name = "repository_url")
    private String repositoryUrl;

    @Column(name = "stars_count")
    private Integer starsCount;

    @Column(name = "forks_count")
    private Integer forksCount;

    @Column(name = "stars_today")
    private Integer starsToday;

    @Column(name = "author")
    private String author;

    @OneToMany(mappedBy = "repository", cascade = CascadeType.ALL)
    private List<TrendingRecord> trendingRecords = new ArrayList<>();
}