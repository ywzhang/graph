package com.xbstar.graph;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.xbstar.graph.dao")
public class GraphApplication {

    public static void main(String[] args) {
        SpringApplication.run(GraphApplication.class, args);
    }

}
