package com.github.trending.controller;

import com.github.trending.entity.Task;
import com.github.trending.entity.Task.TaskStatus;
import com.github.trending.entity.Task.TaskType;
import com.github.trending.service.TaskService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class TaskController {

    private final TaskService taskService;

    /**
     * 创建新任务
     */
    @PostMapping
    public ResponseEntity<Task> createTask(@RequestBody Task task) {
        return ResponseEntity.ok(taskService.createTask(task));
    }

    /**
     * 获取所有任务
     */
    @GetMapping
    public ResponseEntity<List<Task>> getAllTasks() {
        return ResponseEntity.ok(taskService.getAllTasks());
    }

    /**
     * 根据状态获取任务
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Task>> getTasksByStatus(@PathVariable TaskStatus status) {
        return ResponseEntity.ok(taskService.getTasksByStatus(status));
    }

    /**
     * 根据类型获取任务
     */
    @GetMapping("/type/{type}")
    public ResponseEntity<List<Task>> getTasksByType(@PathVariable TaskType type) {
        return ResponseEntity.ok(taskService.getTasksByType(type));
    }

    /**
     * 手动执行任务
     */
    @PostMapping("/{taskId}/execute")
    public ResponseEntity<Void> executeTask(@PathVariable Long taskId) {
        taskService.executeTask(taskId);
        return ResponseEntity.ok().build();
    }

    /**
     * 更新任务状态
     */
    @PutMapping("/{taskId}/status")
    public ResponseEntity<Task> updateTaskStatus(
            @PathVariable Long taskId,
            @RequestParam TaskStatus status,
            @RequestParam(required = false) String errorMessage) {
        return ResponseEntity.ok(taskService.updateTaskStatus(taskId, status, errorMessage));
    }
}