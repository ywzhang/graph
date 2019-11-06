package com.xbstar.graph;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.IOException;

@SpringBootApplication

public class GraphApplication {

    public static void main(String[] args) throws IOException {
        SpringApplication.run(GraphApplication.class, args);
        //GraphController.listClass();
    }

}
