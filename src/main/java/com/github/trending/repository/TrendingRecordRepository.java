package com.github.trending.repository;

import com.github.trending.entity.TrendingRecord;
import com.github.trending.entity.TrendingRecord.TrendingType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface TrendingRecordRepository extends JpaRepository<TrendingRecord, Long> {
    List<TrendingRecord> findByDateAndTypeOrderByRankAsc(LocalDate date, TrendingType type);
    
    List<TrendingRecord> findByTypeAndDateBetweenOrderByDateDesc(
        TrendingType type,
        LocalDate startDate,
        LocalDate endDate
    );
}