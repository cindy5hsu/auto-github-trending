package com.github.trending.scheduler;

import com.github.trending.entity.Repository;
import com.github.trending.entity.TrendingRecord;
import com.github.trending.entity.TrendingRecord.TrendingType;
import com.github.trending.repository.RepositoryRepository;
import com.github.trending.repository.TrendingRecordRepository;
import com.github.trending.service.TrendingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Component
public class TrendingScheduler {

    @Autowired
    private TrendingService trendingService;
    
    @Autowired
    private RepositoryRepository repositoryRepository;
    
    @Autowired
    private TrendingRecordRepository trendingRecordRepository;

    /**
     * 每6小时抓取一次每日趋势数据
     */
    @Scheduled(cron = "${github.trending.cron.daily}")
    @Transactional
    public void scheduleDailyTrendingFetch() {
        List<Repository> repositories = trendingService.fetchDailyTrending();
        saveTrendingData(repositories, TrendingType.DAILY);
    }

    /**
     * 每周一抓取一次每周趋势数据
     */
    @Scheduled(cron = "${github.trending.cron.weekly}")
    @Transactional
    public void scheduleWeeklyTrendingFetch() {
        List<Repository> repositories = trendingService.fetchWeeklyTrending();
        saveTrendingData(repositories, TrendingType.WEEKLY);
    }
    
    /**
     * 保存趋势数据到数据库
     * @param repositories 仓库列表
     * @param type 趋势类型（每日/每周）
     */
    private void saveTrendingData(List<Repository> repositories, TrendingType type) {
        List<TrendingRecord> records = new ArrayList<>();
        int rank = 1;
        
        for (Repository repo : repositories) {
            // 保存或更新仓库信息
            Repository savedRepo = repositoryRepository.findByOwnerAndName(
                    repo.getOwner() != null ? repo.getOwner() : repo.getAuthor(), 
                    repo.getName())
                .orElse(repo);
            
            if (savedRepo.getId() == null) {
                savedRepo = repositoryRepository.save(repo);
            }
            
            // 创建趋势记录
            TrendingRecord record = new TrendingRecord();
            record.setRepository(savedRepo);
            record.setDate(LocalDate.now());
            record.setRank(rank++);
            record.setType(type);
            record.setStarsGained(repo.getStarsToday());
            records.add(record);
        }
        
        // 批量保存趋势记录
        trendingRecordRepository.saveAll(records);
    }
}