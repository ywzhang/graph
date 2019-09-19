package com.xbstar.graph.controller;

import com.xbstar.graph.service.PersonSerivce;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by Simon on 2019/9/12 15:09
 */
@Controller
@RequestMapping("/graph")
public class GraphController {
    @Autowired
    PersonSerivce personSerivce;

    @RequestMapping("/index")
    public String index(){
        //jsonString数据
        return "graph";
    }


}
