package com.github.trending.service.impl;

import com.github.trending.entity.Task;
import com.github.trending.entity.Task.TaskStatus;
import com.github.trending.entity.Task.TaskType;
import com.github.trending.repository.TaskRepository;
import com.github.trending.service.TaskService;
import com.github.trending.service.TrendingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class TaskServiceImpl implements TaskService {

    private final TaskRepository taskRepository;
    private final TrendingService trendingService;

    @Override
    @Transactional
    public Task createTask(Task task) {
        task.setStatus(TaskStatus.PENDING);
        return taskRepository.save(task);
    }

    @Override
    @Transactional
    public Task updateTaskStatus(Long taskId, TaskStatus status, String errorMessage) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Task not found: " + taskId));
        
        task.setStatus(status);
        if (errorMessage != null) {
            task.setErrorMessage(errorMessage);
        }
        if (status == TaskStatus.COMPLETED || status == TaskStatus.FAILED) {
            task.setCompletedAt(LocalDateTime.now());
        }
        
        return taskRepository.save(task);
    }

    @Override
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    @Override
    public List<Task> getTasksByStatus(TaskStatus status) {
        return taskRepository.findByStatus(status);
    }

    @Override
    public List<Task> getTasksByType(TaskType type) {
        return taskRepository.findByType(type);
    }

    @Override
    @Transactional
    public void executeTask(Long taskId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Task not found: " + taskId));

        try {
            updateTaskStatus(taskId, TaskStatus.RUNNING, null);
            
            switch (task.getType()) {
                case DAILY_TRENDING:
                    trendingService.fetchDailyTrending();
                    break;
                case WEEKLY_TRENDING:
                    trendingService.fetchWeeklyTrending();
                    break;
                case LANGUAGE_TRENDING:
                    if (task.getName() != null) {
                        trendingService.fetchTrendingByLanguage(task.getName());
                    }
                    break;
            }
            
            updateTaskStatus(taskId, TaskStatus.COMPLETED, null);
        } catch (Exception e) {
            log.error("Task execution failed: " + taskId, e);
            updateTaskStatus(taskId, TaskStatus.FAILED, e.getMessage());
        }
    }

    @Override
    @Scheduled(fixedDelay = 60000) // 每分钟检查一次
    @Transactional
    public void schedulePendingTasks() {
        List<Task> pendingTasks = taskRepository.findByStatusAndScheduledAtBefore(
            TaskStatus.PENDING,
            LocalDateTime.now()
        );

        for (Task task : pendingTasks) {
            try {
                executeTask(task.getId());
            } catch (Exception e) {
                log.error("Failed to execute scheduled task: " + task.getId(), e);
            }
        }
    }
}