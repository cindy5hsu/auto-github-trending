package com.github.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "trending_records")
public class TrendingRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "repository_id", nullable = false)
    private Repository repository;

    @Column(nullable = false)
    private java.time.LocalDate date;

    @Column(nullable = false)
    private Integer rank;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private TrendingType type;

    @Column(name = "stars_gained", nullable = false)
    private Integer starsGained;

    @Column(name = "created_at", nullable = false)
    private java.time.LocalDateTime createdAt;

    public enum TrendingType {
        DAILY,
        WEEKLY
    }

    @PrePersist
    protected void onCreate() {
        createdAt = java.time.LocalDateTime.now();
    }
}