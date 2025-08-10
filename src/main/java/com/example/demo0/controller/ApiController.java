package com.example.demo0.controller;

import com.example.demo0.dto.TimeStampResponseInstant;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

@RestController
public class ApiController {

    @GetMapping
    public ResponseEntity<TimeStampResponseInstant> helloAws(){
        return ResponseEntity.ok(new TimeStampResponseInstant(Instant.now()));
    }
}
