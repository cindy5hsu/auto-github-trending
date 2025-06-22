package com.github.trending.service;

import com.github.trending.entity.Repository;
import com.github.trending.entity.TrendingRecord;
import com.github.trending.entity.TrendingRecord.TrendingType;
import com.github.trending.repository.TrendingRecordRepository;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class GithubTrendingService {

    @Value("${github.trending.base-url}")
    private String baseUrl;

    private final TrendingRecordRepository trendingRecordRepository;

    public GithubTrendingService(TrendingRecordRepository trendingRecordRepository) {
        this.trendingRecordRepository = trendingRecordRepository;
    }

    @Transactional
    public List<TrendingRecord> fetchDailyTrending() {
        return fetchTrending(TrendingType.DAILY, "");
    }

    @Transactional
    public List<TrendingRecord> fetchWeeklyTrending() {
        return fetchTrending(TrendingType.WEEKLY, "?since=weekly");
    }

    private List<TrendingRecord> fetchTrending(TrendingType type, String params) {
        try {
            Document doc = Jsoup.connect(baseUrl + params).get();
            Elements repositories = doc.select("article.Box-row");
            List<TrendingRecord> records = new ArrayList<>();
            int rank = 1;

            for (Element repo : repositories) {
                try {
                    Repository repository = parseRepository(repo);
                    TrendingRecord record = new TrendingRecord();
                    record.setRepository(repository);
                    record.setDate(LocalDate.now());
                    record.setRank(rank++);
                    record.setType(type);
                    record.setStarsGained(parseStarsGained(repo));
                    records.add(record);
                } catch (Exception e) {
                    // 记录错误但继续处理其他仓库
                    System.err.println("Error parsing repository: " + e.getMessage());
                }
            }

            return trendingRecordRepository.saveAll(records);
        } catch (IOException e) {
            throw new RuntimeException("Failed to fetch trending repositories", e);
        }
    }

    private Repository parseRepository(Element element) {
        Repository repository = new Repository();
        Element titleElement = element.select("h2.h3.lh-condensed").first();
        // 使用href屬性獲取準確的URL路徑
        String repoPath = titleElement.select("a").attr("href");
        // 確保路徑以/開頭，並去除開頭的/
        if (repoPath.startsWith("/")) {
            repoPath = repoPath.substring(1);
        }
        String[] nameAndOwner = repoPath.split("/");
        
        String owner = nameAndOwner[0];
        String name = nameAndOwner[1];
        repository.setOwner(owner);
        repository.setName(name);
        // 确保设置正确的GitHub URL
        String githubUrl = "https://github.com/" + owner + "/" + name;
        repository.setUrl(githubUrl);
        repository.setRepositoryUrl(githubUrl); // 確保同時設置兩個URL屬性為相同的值
        // 设置author字段，用于前端显示
        repository.setAuthor(owner);
        
        Element descriptionElement = element.select("p.col-9.color-fg-muted.my-1.pr-4").first();
        if (descriptionElement != null) {
            repository.setDescription(descriptionElement.text());
        }

        Elements languageElement = element.select("span[itemprop=programmingLanguage]");
        if (!languageElement.isEmpty()) {
            repository.setLanguage(languageElement.text());
        }

        Elements statsElements = element.select("a.Link--muted.d-inline-block.mr-3");
        for (Element stat : statsElements) {
            String text = stat.text().trim();
            if (text.contains("stars")) {
                repository.setStars(parseNumber(text));
            } else if (text.contains("forks")) {
                repository.setForks(parseNumber(text));
            }
        }

        return repository;
    }

    private Integer parseStarsGained(Element element) {
        Elements starsGainedElement = element.select("span.d-inline-block.float-sm-right");
        if (!starsGainedElement.isEmpty()) {
            String text = starsGainedElement.text().trim();
            return parseNumber(text.split(" ")[0]);
        }
        return 0;
    }

    private Integer parseNumber(String text) {
        text = text.replaceAll(",", "");
        Pattern pattern = Pattern.compile("\\d+(\\.\\d+)?[kKmM]?");
        Matcher matcher = pattern.matcher(text);
        
        if (matcher.find()) {
            String number = matcher.group();
            if (number.matches(".*[kK]")) {
                return (int) (Double.parseDouble(number.substring(0, number.length() - 1)) * 1000);
            } else if (number.matches(".*[mM]")) {
                return (int) (Double.parseDouble(number.substring(0, number.length() - 1)) * 1000000);
            } else {
                return (int) Double.parseDouble(number);
            }
        }
        return 0;
    }
}