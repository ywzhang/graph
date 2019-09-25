package com.xbstar.graph.controller;

import com.alibaba.fastjson.JSONObject;
import com.xbstar.graph.dao.InstitutionMapper;
import com.xbstar.graph.dao.PersonMapper;
import com.xbstar.graph.domain.Institution;
import com.xbstar.graph.domain.Person;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by Simon on 2019/9/12 15:09
 */
@Controller
@RequestMapping("/graph")
public class GraphController {
    @Resource
    PersonMapper mapper;
    @Resource
    InstitutionMapper institutionMapper;

    @RequestMapping("/index")
    public String index(Model model){
        //jsonString数据
//        model.addAttribute("dataJson",findAll().toJSONString());
        return "graph";
    }

    @RequestMapping("/findAll")
    @ResponseBody
    public JSONObject findAll(){
        JSONObject dataJSon = new JSONObject();
        List categories = new ArrayList();
        List nodes = new ArrayList();
        List links = new ArrayList();
        AtomicInteger i = new AtomicInteger(1);
        List<Person> persons = mapper.findAll();
        JSONObject node1 = new JSONObject();
        node1.put("id",i.getAndIncrement()+"");
        node1.put("name","老人");
        node1.put("value",null);
        node1.put("category",0);
        node1.put("label","老人");
        node1.put("symbolSize",25);
        nodes.add(node1);
        persons.stream().forEach(item->{
            JSONObject node2 = new JSONObject();
            node2.put("id", i.getAndIncrement()+"");
            node2.put("name",item.getName());
            node2.put("value",item.getId());
            node2.put("category",1);
            node2.put("label",item.getName());
            node2.put("symbolSize",20);
            nodes.add(node2);

            JSONObject link1 = new JSONObject();
            link1.put("source",node2.getString("id"));
            link1.put("target",node1.getString("id"));
            link1.put("label",node2.get("name")+"->"+node1.get("name"));
            links.add(link1);
        });

        List<String> list = new ArrayList<>(Arrays.asList("老人", "姓名"));
        list.stream().forEach(item->{
            JSONObject category = new JSONObject();
            category.put("name",item);
            categories.add(category);
        });
        dataJSon.put("categories",categories);
        dataJSon.put("nodes",nodes);
        dataJSon.put("links",links);
        return dataJSon;
    }

    @RequestMapping("/findById")
    @ResponseBody
    public JSONObject findById(long id,String category){
        JSONObject dataJSon = new JSONObject();
        List categories = new ArrayList();
        List nodes = new ArrayList();
        List links = new ArrayList();
        switch (category){
            case "姓名":
                Person person = mapper.findById(id);
                JSONObject json1 = new JSONObject();
                json1.put("id","1");
                json1.put("name",person.getName());
                json1.put("value",null);
                json1.put("category",0);
                json1.put("label",person.getName());
                json1.put("symbolSize",25);
                JSONObject json2 = new JSONObject();
                json2.put("id","2");
                json2.put("name",person.getAddress());
                json2.put("value",null);
                json2.put("category",1);
                json2.put("label",person.getAddress());
                json2.put("symbolSize",20);
                JSONObject json3 = new JSONObject();
                json3.put("id","3");
                json3.put("name",person.getTelephone());
                json3.put("value",null);
                json3.put("category",2);
                json3.put("label",person.getTelephone());
                json3.put("symbolSize",20);
                JSONObject json4 = new JSONObject();
                json4.put("id","4");
                json4.put("name",person.getBirthday());
                json4.put("value",null);
                json4.put("category",3);
                json4.put("label",person.getBirthday());
                json4.put("symbolSize",20);
                JSONObject json5 = new JSONObject();
                json5.put("id","5");
                json5.put("name",person.getIdentity());
                json5.put("value",null);
                json5.put("category",4);
                json5.put("label",person.getIdentity());
                json5.put("symbolSize",20);
                JSONObject json6 = new JSONObject();
                json6.put("id","6");
                json6.put("name",person.getInstitution_name());
                json6.put("value",person.getInstitution_id());
                json6.put("category",5);
                json6.put("label",person.getInstitution_name());
                json6.put("symbolSize",20);
                nodes.add(json1);
                nodes.add(json2);
                nodes.add(json3);
                nodes.add(json4);
                nodes.add(json5);
                nodes.add(json6);

                for(int i=2;i<=6;i++){
                   JSONObject link = new JSONObject();
                   link.put("source",i+"");
                   link.put("target","1");
                   links.add(link);
                }
                List<String> list = new ArrayList<>(Arrays.asList("姓名","地址","电话","出生日期","身份证","机构"));
                list.stream().forEach(item->{
                    JSONObject category2 = new JSONObject();
                    category2.put("name",item);
                    categories.add(category2);
                });

                dataJSon.put("categories",categories);
                dataJSon.put("nodes",nodes);
                dataJSon.put("links",links);
                break;
            case "机构":
                Institution ins = institutionMapper.findById(id);
                JSONObject insJson1 = new JSONObject();
                insJson1.put("id","1");
                insJson1.put("name",ins.getInstitution_name());
                insJson1.put("value",null);
                insJson1.put("category",0);
                insJson1.put("label",ins.getInstitution_name());
                insJson1.put("symbolSize",25);
                JSONObject insJson2 = new JSONObject();
                insJson2.put("id","2");
                insJson2.put("name",ins.getPrincipal());
                insJson2.put("value",null);
                insJson2.put("category",1);
                insJson2.put("label",ins.getPrincipal());
                insJson2.put("symbolSize",20);
                JSONObject insJson3 = new JSONObject();
                insJson3.put("id","3");
                insJson3.put("name",ins.getAddress());
                insJson3.put("value",null);
                insJson3.put("category",2);
                insJson3.put("label",ins.getAddress());
                insJson3.put("symbolSize",20);
                nodes.add(insJson1);
                nodes.add(insJson2);
                nodes.add(insJson3);

                for(int i=2;i<=3;i++){
                    JSONObject link = new JSONObject();
                    link.put("source",i+"");
                    link.put("target","1");
                    links.add(link);
                }
                List<String> list2 = new ArrayList<>(Arrays.asList("机构名","负责人","地址"));
                list2.stream().forEach(item->{
                    JSONObject category2 = new JSONObject();
                    category2.put("name",item);
                    categories.add(category2);
                });

                dataJSon.put("categories",categories);
                dataJSon.put("nodes",nodes);
                dataJSon.put("links",links);
                break;
            default:
                break;
        }
        return dataJSon;
    }
}
