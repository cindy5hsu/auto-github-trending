package com.github.trending.service;

import com.github.trending.entity.Repository;
import java.util.List;

public interface TrendingService {
    /**
     * 抓取每日趋势仓库数据
     * @return 趋势仓库列表
     */
    List<Repository> fetchDailyTrending();
    
    /**
     * 抓取每日趋势仓库数据（带语言筛选）
     * @param language 编程语言
     * @return 趋势仓库列表
     */
    List<Repository> fetchDailyTrending(String language);

    /**
     * 抓取每周趋势仓库数据
     * @return 趋势仓库列表
     */
    List<Repository> fetchWeeklyTrending();
    
    /**
     * 抓取每周趋势仓库数据（带语言筛选）
     * @param language 编程语言
     * @return 趋势仓库列表
     */
    List<Repository> fetchWeeklyTrending(String language);

    /**
     * 根据编程语言抓取趋势仓库数据
     * @param language 编程语言
     * @return 趋势仓库列表
     */
    List<Repository> fetchTrendingByLanguage(String language);

    /**
     * 抓取趋势仓库数据（支持分页）
     * @param language 编程语言
     * @param period 时间周期（daily/weekly）
     * @param page 页码
     * @param size 每页大小
     * @return 趋势仓库列表
     */
    List<Repository> fetchTrending(String language, String period, int page, int size);
}