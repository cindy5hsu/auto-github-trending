package com.github.trending.repository;

import com.github.trending.entity.Task;
import com.github.trending.entity.Task.TaskStatus;
import com.github.trending.entity.Task.TaskType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByStatus(TaskStatus status);
    
    List<Task> findByType(TaskType type);
    
    List<Task> findByStatusAndScheduledAtBefore(
        TaskStatus status,
        LocalDateTime dateTime
    );
    
    List<Task> findByTypeAndStatusOrderByCreatedAtDesc(
        TaskType type,
        TaskStatus status
    );
}