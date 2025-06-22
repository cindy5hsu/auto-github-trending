package com.github.trending.service;

import com.github.trending.entity.Task;
import com.github.trending.entity.Task.TaskType;
import com.github.trending.entity.Task.TaskStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class TaskSchedulerService {

    private final GithubTrendingService githubTrendingService;

    public TaskSchedulerService(GithubTrendingService githubTrendingService) {
        this.githubTrendingService = githubTrendingService;
    }

    @Scheduled(cron = "${github.trending.cron.daily}")
    @Transactional
    public void scheduleDailyTrendingTask() {
        Task task = createTask(TaskType.DAILY_TRENDING, "Fetch daily trending repositories");
        try {
            githubTrendingService.fetchDailyTrending();
            completeTask(task);
        } catch (Exception e) {
            failTask(task, e.getMessage());
            throw e;
        }
    }

    @Scheduled(cron = "${github.trending.cron.weekly}")
    @Transactional
    public void scheduleWeeklyTrendingTask() {
        Task task = createTask(TaskType.WEEKLY_TRENDING, "Fetch weekly trending repositories");
        try {
            githubTrendingService.fetchWeeklyTrending();
            completeTask(task);
        } catch (Exception e) {
            failTask(task, e.getMessage());
            throw e;
        }
    }

    private Task createTask(TaskType type, String description) {
        Task task = new Task();
        task.setType(type);
        task.setName(type.name());
        task.setDescription(description);
        task.setStatus(TaskStatus.RUNNING);
        task.setScheduledAt(LocalDateTime.now());
        return task;
    }

    private void completeTask(Task task) {
        task.setStatus(TaskStatus.COMPLETED);
        task.setCompletedAt(LocalDateTime.now());
    }

    private void failTask(Task task, String errorMessage) {
        task.setStatus(TaskStatus.FAILED);
        task.setCompletedAt(LocalDateTime.now());
        task.setErrorMessage(errorMessage);
    }
}