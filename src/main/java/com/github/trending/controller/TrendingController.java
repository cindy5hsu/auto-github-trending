package com.github.trending.controller;

import com.github.trending.entity.Repository;
import com.github.trending.service.TrendingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

@RestController
@RequestMapping("/api/trending")
public class TrendingController {
    
    private static final Logger logger = LoggerFactory.getLogger(TrendingController.class);

    @Autowired
    private TrendingService trendingService;

    /**
     * 获取每日趋势仓库
     */
    @GetMapping("/daily")
    public ResponseEntity<List<Repository>> getDailyTrending(
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "50") int size,
            @RequestParam(required = false, defaultValue = "") String language) {
        logger.info("接收到每日趋势请求: page={}, size={}, language={}", page, size, language);
        List<Repository> result = trendingService.fetchTrending(language, "daily", page, size);
        logger.info("返回每日趋势结果数量: {}", result.size());
        return ResponseEntity.ok(result);
    }

    /**
     * 获取每周趋势仓库
     */
    /**
     * 获取每周趋势仓库
     */
    @GetMapping("/weekly")
    public ResponseEntity<List<Repository>> getWeeklyTrending(
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "50") int size,
            @RequestParam(required = false, defaultValue = "") String language) {
        logger.info("接收到每周趋势请求: page={}, size={}, language={}", page, size, language);
        List<Repository> result = trendingService.fetchTrending(language, "weekly", page, size);
        logger.info("返回每周趋势结果数量: {}", result.size());
        return ResponseEntity.ok(result);
    }

    /**
     * 获取指定语言的趋势仓库
     */
    @GetMapping("/language/{language}")
    public ResponseEntity<List<Repository>> getTrendingByLanguage(
            @PathVariable String language,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "50") int size) {
        logger.info("接收到语言趋势请求: language={}, page={}, size={}", language, page, size);
        List<Repository> result = trendingService.fetchTrending(language, "daily", page, size);
        logger.info("返回语言趋势结果数量: {}", result.size());
        return ResponseEntity.ok(result);
    }
}