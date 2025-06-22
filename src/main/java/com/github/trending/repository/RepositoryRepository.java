package com.github.trending.repository;

import com.github.trending.entity.Repository;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RepositoryRepository extends JpaRepository<Repository, Long> {
    Optional<Repository> findByOwnerAndName(String owner, String name);
}