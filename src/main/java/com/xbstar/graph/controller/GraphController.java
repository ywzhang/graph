package com.xbstar.graph.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by Simon on 2019/9/12 15:09
 */
@Controller
@RequestMapping("/graph")
public class GraphController {

    @RequestMapping("/index")
    public String index(){
        //jsonString数据
        return "graph";
    }

}
