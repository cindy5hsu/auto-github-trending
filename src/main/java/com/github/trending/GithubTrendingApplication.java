package com.github.trending;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = {"com.github.trending", "com.github.trendingcrawler"})
// 原包扫描范围保留，确保正确扫描当前模块，并添加trendingcrawler包以支持错误控制器
@EnableJpaRepositories(basePackages = "com.github.trending.repository")
public class GithubTrendingApplication {
    public static void main(String[] args) {
        SpringApplication.run(GithubTrendingApplication.class, args);
    }
}