package com.github.trending.service;

import com.github.trending.entity.Task;
import com.github.trending.entity.Task.TaskStatus;
import com.github.trending.entity.Task.TaskType;

import java.util.List;

public interface TaskService {
    /**
     * 创建新任务
     */
    Task createTask(Task task);

    /**
     * 更新任务状态
     */
    Task updateTaskStatus(Long taskId, TaskStatus status, String errorMessage);

    /**
     * 获取所有任务
     */
    List<Task> getAllTasks();

    /**
     * 根据状态获取任务
     */
    List<Task> getTasksByStatus(TaskStatus status);

    /**
     * 根据类型获取任务
     */
    List<Task> getTasksByType(TaskType type);

    /**
     * 执行任务
     */
    void executeTask(Long taskId);

    /**
     * 调度待执行的任务
     */
    void schedulePendingTasks();
}