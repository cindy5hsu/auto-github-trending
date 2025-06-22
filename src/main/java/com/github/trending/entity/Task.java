package com.github.trending.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "tasks")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TaskType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TaskStatus status;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    private LocalDateTime scheduledAt;

    private LocalDateTime completedAt;

    private String cronExpression;

    @Column(length = 2000)
    private String errorMessage;

    public enum TaskType {
        DAILY_TRENDING,
        WEEKLY_TRENDING,
        LANGUAGE_TRENDING
    }

    public enum TaskStatus {
        PENDING,
        RUNNING,
        COMPLETED,
        FAILED
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null) {
            status = TaskStatus.PENDING;
        }
    }
}