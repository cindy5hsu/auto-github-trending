package com.github.trending.service;

import com.github.trending.entity.Repository;
import com.github.trending.entity.TrendingRecord;
import com.github.trending.entity.TrendingRecord.TrendingType;
import com.github.trending.repository.RepositoryRepository;
import com.github.trending.repository.TrendingRecordRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Service
@RequiredArgsConstructor
public class TrendingCrawlerService {

    private final RepositoryRepository repositoryRepository;
    private final TrendingRecordRepository trendingRecordRepository;

    @Value("${github.trending.base-url}")
    private String baseUrl;

    @Scheduled(cron = "${github.trending.cron.daily}")
    @Transactional
    public void crawlDailyTrending() {
        crawlTrending(TrendingType.DAILY);
    }

    @Scheduled(cron = "${github.trending.cron.weekly}")
    @Transactional
    public void crawlWeeklyTrending() {
        crawlTrending(TrendingType.WEEKLY);
    }

    private void crawlTrending(TrendingType type) {
        try {
            String url = type == TrendingType.DAILY ? baseUrl : baseUrl + "?since=weekly";
            Document doc = Jsoup.connect(url).get();
            Elements articles = doc.select("article.Box-row");

            List<TrendingRecord> records = new ArrayList<>();
            int rank = 1;

            for (Element article : articles) {
                try {
                    Repository repository = parseRepository(article);
                    TrendingRecord record = createTrendingRecord(repository, rank++, type, article);
                    records.add(record);
                } catch (Exception e) {
                    log.error("Error parsing repository at rank {}: {}", rank, e.getMessage());
                }
            }

            trendingRecordRepository.saveAll(records);
            log.info("Successfully crawled {} trending repositories", records.size());

        } catch (IOException e) {
            log.error("Error crawling {} trending: {}", type, e.getMessage());
        }
    }

    private Repository parseRepository(Element article) {
        Element titleElement = article.selectFirst("h2.h3.lh-condensed");
        String[] nameComponents = titleElement.text().split("/");
        String owner = nameComponents[0].trim();
        String name = nameComponents[1].trim();

        String url = "https://github.com/" + owner + "/" + name;
        String description = Optional.ofNullable(article.select("p.col-9").first())
                .map(Element::text)
                .orElse("");

        String language = Optional.ofNullable(article.selectFirst("span[itemprop=programmingLanguage]"))
                .map(Element::text)
                .orElse(null);

        Integer stars = extractNumber(article.selectFirst("a.Link--muted[href*='/stargazers']"));
        Integer forks = extractNumber(article.selectFirst("a.Link--muted[href*='/forks']"));

        Repository repository = repositoryRepository.findByOwnerAndName(owner, name)
                .orElse(new Repository());
        repository.setOwner(owner);
        repository.setName(name);
        repository.setRepositoryUrl(url);
        repository.setUrl(url); // 同時設置url屬性，確保兩個URL一致
        repository.setAuthor(owner); // 設置author字段，用於前端顯示
        repository.setDescription(description);
        repository.setLanguage(language);
        repository.setStarsCount(stars);
        repository.setForksCount(forks);

        return repositoryRepository.save(repository);
    }

    private TrendingRecord createTrendingRecord(Repository repository, int rank, TrendingType type, Element article) {
        TrendingRecord record = new TrendingRecord();
        record.setRepository(repository);
        record.setDate(LocalDate.now());
        record.setRank(rank);
        record.setType(type);

        // 解析获得的星标数
        Element starGainedElement = article.selectFirst("span.d-inline-block.float-sm-right");
        if (starGainedElement != null) {
            String starText = starGainedElement.text().trim();
            Pattern pattern = Pattern.compile("\\d+");
            Matcher matcher = pattern.matcher(starText);
            if (matcher.find()) {
                record.setStarsGained(Integer.parseInt(matcher.group()));
            }
        }

        return record;
    }

    private Integer extractNumber(Element element) {
        if (element == null) return 0;
        String text = element.text().trim().replace(",", "");
        Pattern pattern = Pattern.compile("\\d+");
        Matcher matcher = pattern.matcher(text);
        return matcher.find() ? Integer.parseInt(matcher.group()) : 0;
    }
}