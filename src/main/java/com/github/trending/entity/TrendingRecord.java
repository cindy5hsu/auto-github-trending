package com.github.trending.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Data
@Entity
@Table(name = "trending_records")
public class TrendingRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "repository_id", nullable = false)
    private Repository repository;

    @Column(nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private Integer rank;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrendingType type;

    private Integer starsGained;

    public enum TrendingType {
        DAILY,
        WEEKLY
    }
}