package com.github.trending.controller;

import com.github.trending.entity.Task;
// import com.github.trending.entity.Task.TaskStatus;
import com.github.trending.entity.Task.TaskType;
import com.github.trending.service.TaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/tasks")
@RequiredArgsConstructor
public class TaskExecutionController {

    private final TaskService taskService;

    /**
     * 手动执行任务 - 执行每日趋势抓取
     */
    @PostMapping("/execute/manual")
    public ResponseEntity<Map<String, Object>> executeManualTask() {
        log.info("Executing manual daily trending task");
        Task task = new Task();
        task.setName("Manual Daily Trending");
        task.setDescription("Manually triggered daily trending task");
        task.setType(TaskType.DAILY_TRENDING);
        task.setScheduledAt(LocalDateTime.now());
        
        Task savedTask = taskService.createTask(task);
        taskService.executeTask(savedTask.getId());
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Manual task execution started");
        response.put("taskId", savedTask.getId());
        
        return ResponseEntity.ok(response);
    }

    /**
     * 执行自动任务 - 执行每周趋势抓取
     */
    @PostMapping("/execute/auto")
    public ResponseEntity<Map<String, Object>> executeAutoTask() {
        log.info("Executing auto weekly trending task");
        Task task = new Task();
        task.setName("Auto Weekly Trending");
        task.setDescription("Automatically triggered weekly trending task");
        task.setType(TaskType.WEEKLY_TRENDING);
        task.setScheduledAt(LocalDateTime.now());
        
        Task savedTask = taskService.createTask(task);
        taskService.executeTask(savedTask.getId());
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Auto task execution started");
        response.put("taskId", savedTask.getId());
        
        return ResponseEntity.ok(response);
    }
    /**
     * 获取任务执行记录
     */
    @GetMapping("/execution-records")
    public ResponseEntity<List<Task>> getExecutionRecords() {
        log.info("Fetching task execution records");
        List<Task> tasks = taskService.getAllTasks();
        return ResponseEntity.ok(tasks);
    }
}