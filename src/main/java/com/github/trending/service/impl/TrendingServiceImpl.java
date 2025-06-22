package com.github.trending.service.impl;

import com.github.trending.entity.Repository;
import com.github.trending.entity.TrendingRecord;
import com.github.trending.repository.RepositoryRepository;
import com.github.trending.repository.TrendingRecordRepository;
import com.github.trending.service.TrendingService;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TrendingServiceImpl implements TrendingService {

    @Value("${github.trending.base-url}")
    private String baseUrl;

    @Override
    public List<Repository> fetchDailyTrending() {
        return fetchTrending("", "daily", 1, 10);
    }
    
    @Override
    public List<Repository> fetchDailyTrending(String language) {
        return fetchTrending(language, "daily", 1, 10);
    }

    @Override
    public List<Repository> fetchWeeklyTrending() {
        return fetchTrending("", "weekly", 1, 10);
    }
    
    @Override
    public List<Repository> fetchWeeklyTrending(String language) {
        return fetchTrending(language, "weekly", 1, 10);
    }

    @Override
    public List<Repository> fetchTrendingByLanguage(String language) {
        return fetchTrending(language, "daily", 1, 10);
    }

    @Autowired
    private TrendingRecordRepository trendingRecordRepository;
    
    @Autowired
    private RepositoryRepository repositoryRepository;
    
    @Override
    public List<Repository> fetchTrending(String language, String period, int page, int size) {
        try {
            // 首先尝试从GitHub获取数据
            return fetchTrendingFromGitHub(language, period, page, size);
        } catch (Exception e) {
            // 如果从GitHub获取失败，则从数据库获取数据
            System.out.println("从GitHub获取数据失败，尝试从数据库获取: " + e.getMessage());
            return fetchTrendingFromDatabase(language, period, page, size);
        }
    }
    
    private List<Repository> fetchTrendingFromDatabase(String language, String period, int page, int size) {
        System.out.println("从数据库获取数据: language=" + language + ", period=" + period + ", page=" + page + ", size=" + size);
        
        // 确定查询类型（每日或每周）
        TrendingRecord.TrendingType type = "weekly".equals(period) ? 
                TrendingRecord.TrendingType.WEEKLY : TrendingRecord.TrendingType.DAILY;
        
        // 获取最近的记录日期
        LocalDate today = LocalDate.now();
        LocalDate startDate = today.minusDays(7); // 获取最近7天的数据
        
        // 从数据库获取趋势记录
        List<TrendingRecord> records = trendingRecordRepository.findByTypeAndDateBetweenOrderByDateDesc(
                type, startDate, today);
        
        System.out.println("从数据库获取到记录数: " + records.size());
        
        // 提取仓库信息并过滤语言（如果指定）
        List<Repository> repositories = records.stream()
                .map(TrendingRecord::getRepository)
                .filter(repo -> language == null || language.isEmpty() || "all".equalsIgnoreCase(language) || 
                        (repo.getLanguage() != null && repo.getLanguage().equalsIgnoreCase(language)))
                .distinct()
                .collect(Collectors.toList());
        
        // 分页处理
        int start = (page - 1) * size;
        int end = Math.min(start + size, repositories.size());
        
        if (start >= repositories.size()) {
            return new ArrayList<>();
        }
        
        return repositories.subList(start, end);
    }
    
    private List<Repository> fetchTrendingFromGitHub(String language, String period, int page, int size) {
        String url = baseUrl;
        // 處理language參數，當language為"all"或空字串時，不添加到URL中
        if (language != null && !language.isEmpty() && !"all".equalsIgnoreCase(language)) {
            url += "/" + language;
        }
        
        // 處理period參數
        String periodParam = "";
        if ("weekly".equals(period)) {
            periodParam = "?since=weekly";
        }
        url += periodParam;
        
        System.out.println("爬取 URL：" + url);
        System.out.println("參數信息：language=" + language + ", period=" + period + ", page=" + page + ", size=" + size);

        try {
            System.out.println("開始連接URL: " + url);
            // 设置更长的超时时间和用户代理
            Document doc = Jsoup.connect(url)
                .timeout(30000) // 30秒超时
                .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
                .get();
                
            Elements repositories = doc.select("article.Box-row");
            System.out.println("找到倉庫數量: " + repositories.size());
            
            if (repositories.isEmpty()) {
                System.out.println("警告：未找到任何仓库，可能是选择器不匹配或GitHub页面结构已更改");
                throw new IOException("No repositories found, selector might be outdated");
            }
            
            List<Repository> trendingRepos = new ArrayList<>();

            for (Element repo : repositories) {
                try {
                    Repository repository = new Repository();
                    
                    // 解析仓库名称和作者
                    Element titleElement = repo.selectFirst("h2.h3.lh-condensed");
                    if (titleElement == null) {
                        System.out.println("警告：无法找到标题元素，跳过此仓库");
                        continue;
                    }
                    
                    String titleText = titleElement.text();
                    if (!titleText.contains("/")) {
                        System.out.println("警告：标题格式不正确，无法解析作者和名称: " + titleText);
                        continue;
                    }
                    
                    String[] nameAndAuthor = titleText.split("/");
                    String author = nameAndAuthor[0].trim();
                    String name = nameAndAuthor[1].trim();
                    repository.setAuthor(author);
                    repository.setName(name);
                    repository.setOwner(author); // 确保owner字段也被设置
                    
                    // 设置仓库URL - 使用href属性获取准确的URL
                    String repoUrl = "https://github.com/" + author + "/" + name;
                    repository.setRepositoryUrl(repoUrl);
                    repository.setUrl(repoUrl); // 同时设置url属性，确保两个URL一致
                    
                    // 解析描述
                    Element descriptionElement = repo.selectFirst("p.col-9.color-fg-muted.my-1.pr-4");
                    if (descriptionElement != null) {
                        repository.setDescription(descriptionElement.text());
                    }
                    
                    // 解析编程语言
                    Element languageElement = repo.selectFirst("span[itemprop=programmingLanguage]");
                    if (languageElement != null) {
                        repository.setLanguage(languageElement.text());
                    }
                    
                    // 解析star数量
                    Element starsElement = repo.selectFirst("a[href*='/stargazers']");
                    if (starsElement != null) {
                        int stars = parseNumber(starsElement.text());
                        repository.setStarsCount(stars);
                        repository.setStars(stars); // 同时设置stars字段
                    }
                    
                    // 解析fork数量
                    Element forksElement = repo.selectFirst("a[href*='/forks']");
                    if (forksElement != null) {
                        int forks = parseNumber(forksElement.text());
                        repository.setForksCount(forks);
                        repository.setForks(forks); // 同时设置forks字段
                    }
                    
                    // 解析今日获得的star数量
                    Element starsTodayElement = repo.selectFirst("span.d-inline-block.float-sm-right");
                    if (starsTodayElement != null) {
                        String starsTodayText = starsTodayElement.text().split(" ")[0];
                        repository.setStarsToday(parseNumber(starsTodayText));
                    }
                    
                    trendingRepos.add(repository);
                } catch (Exception e) {
                    System.out.println("解析仓库时出错: " + e.getMessage());
                    // 继续处理下一个仓库，不中断整个过程
                }
            }
            
            if (trendingRepos.isEmpty()) {
                System.out.println("警告：所有仓库解析都失败了");
                throw new IOException("Failed to parse any repositories");
            }
            
            // 分頁處理
            int start = (page - 1) * size;
            if (start >= trendingRepos.size()) {
                return new ArrayList<>(); // 返回空列表，而不是抛出异常
            }
            
            int end = Math.min(start + size, trendingRepos.size());
            List<Repository> result = trendingRepos.subList(start, end);
            System.out.println("返回結果數量: " + result.size() + ", 總數量: " + trendingRepos.size() + ", 頁碼: " + page + ", 每頁大小: " + size);
            
            // 保存获取到的数据到数据库，以便后续从数据库获取
            try {
                saveRepositoriesToDatabase(result, period);
            } catch (Exception e) {
                System.out.println("保存仓库到数据库时出错: " + e.getMessage());
                // 即使保存失败，仍然返回已获取的数据
            }
            
            return result;
        } catch (IOException e) {
            System.out.println("从GitHub获取数据失败: " + e.getMessage());
            throw new RuntimeException("Failed to fetch trending repositories: " + e.getMessage(), e);
        }
    }
    
    private void saveRepositoriesToDatabase(List<Repository> repositories, String period) {
        LocalDate today = LocalDate.now();
        TrendingRecord.TrendingType type = "weekly".equals(period) ? 
                TrendingRecord.TrendingType.WEEKLY : TrendingRecord.TrendingType.DAILY;
        
        int rank = 1;
        for (Repository repo : repositories) {
            // 先保存或更新Repository
            Repository savedRepo = repositoryRepository.findByOwnerAndName(repo.getOwner(), repo.getName())
                    .orElse(repo);
            
            if (savedRepo != repo) {
                // 更新现有仓库的信息
                savedRepo.setDescription(repo.getDescription());
                savedRepo.setLanguage(repo.getLanguage());
                savedRepo.setStars(repo.getStars());
                savedRepo.setForks(repo.getForks());
                savedRepo.setStarsCount(repo.getStarsCount());
                savedRepo.setForksCount(repo.getForksCount());
                savedRepo.setStarsToday(repo.getStarsToday());
            }
            
            Repository updatedRepo = repositoryRepository.save(savedRepo);
            
            // 创建趋势记录
            TrendingRecord record = new TrendingRecord();
            record.setRepository(updatedRepo);
            record.setDate(today);
            record.setRank(rank++);
            record.setType(type);
            record.setStarsGained(repo.getStarsToday());
            
            trendingRecordRepository.save(record);
        }
        
        System.out.println("成功保存 " + repositories.size() + " 个仓库到数据库");
    }
    
    private Integer parseNumber(String text) {
        try {
            text = text.replaceAll(",", "");
            if (text.contains("k")) {
                double number = Double.parseDouble(text.replace("k", ""));
                return (int) (number * 1000);
            }
            return Integer.parseInt(text);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}