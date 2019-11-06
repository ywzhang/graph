package com.xbstar.graph.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hp.hpl.jena.ontology.Individual;
import com.hp.hpl.jena.ontology.ObjectProperty;
import com.hp.hpl.jena.ontology.OntClass;
import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.rdf.model.StmtIterator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.*;

/**
 * Created by Simon on 2019/9/12 15:09
 */
@Controller
@RequestMapping("/graph")
public class GraphController {

    public static String NS = "http://www.xbstar.com/ontology/pension#";
    public static String rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns";

    public static String nodesPath = "Json\\Nodes.json";
    public static String linksPath = "Json\\Links.json";
    public static String owlPath = "pension.ttl";
    public static OntModel m = ModelFactory.createOntologyModel();

    public static JSONObject listClass = new JSONObject();


    @RequestMapping("/index")
    public String index(Model model){
        //jsonString数据
        try {
            model.addAttribute("dataJson",listClass().toJSONString());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "screen";
    }


    @RequestMapping("/listClass")
    @ResponseBody
    public static JSONObject listClass() throws IOException {
        JSONArray NODE = new JSONArray();
        JSONArray LINK = new JSONArray();
        m.read(owlPath);
        JSONObject dataJSon = new JSONObject(true);
        JSONArray categories = new JSONArray();

        for (Iterator allClass = m.listClasses(); allClass.hasNext();) {
            OntClass ontClass = (OntClass) allClass.next();
            JSONObject node = new JSONObject(true);

            node.put("id", ontClass.getLocalName());
            node.put("category", 0);
            node.put("name", ontClass.getLocalName());
            node.put("label", ontClass.getLocalName());
            node.put("symbolSize", 25);

            NODE.add(node);
            //System.out.println(ontClass.toString());

            // optimization
            for (Iterator subClasses = ontClass.listSubClasses(); subClasses.hasNext();) {
                JSONObject subLink = new JSONObject(true);
                OntClass subClass = (OntClass) subClasses.next();

                subLink.put("source", ontClass.getLocalName());
                subLink.put("target", subClass.getLocalName());
                subLink.put("label", "SubClass Of");

                LINK.add(subLink);
            }
        }

        for(Iterator properties = m.listObjectProperties(); properties.hasNext(); ) {
            ObjectProperty property = (ObjectProperty) properties.next();
            String domain = null;
            String range = null;

            JSONObject link = new JSONObject(true);

            if(property.getRange() != null || property.getDomain() != null) {
                //System.out.println(property);
                domain = property.getDomain().getLocalName();
                range = property.getRange().getLocalName();

                link.put("source", property.getDomain().getLocalName());
                link.put("target", property.getRange().getLocalName());
                link.put("label", property.getLocalName());

                LINK.add(link);
            }
        }

        List<String> list = new ArrayList<>(Arrays.asList("概念", "实例", "数据属性"));
        list.stream().forEach(item->{
            JSONObject category = new JSONObject();
            category.put("name",item);
            categories.add(category);
        });

        dataJSon.put("categories",categories);
        dataJSon.put("nodes",NODE);
        dataJSon.put("links",LINK);

        writeToJson(nodesPath, NODE);
        writeToJson(linksPath, LINK);

        listClass = dataJSon;

        return dataJSon;
    }

    @RequestMapping("/getInstanceByClass")
    @ResponseBody
    public static JSONObject getInstanceByClass(String className) throws IOException {
        JSONArray NODE = new JSONArray();
        JSONArray LINK = new JSONArray();

        listClass.getJSONArray("nodes").stream().forEach(item->{
            NODE.add(item);
        });
        listClass.getJSONArray("links").stream().forEach(item->{
            LINK.add(item);
        });
        m.read(owlPath);
//        listClass();

        JSONObject dataJSon = new JSONObject(true);
        JSONArray nodes = new JSONArray();
        JSONArray links = new JSONArray();
        JSONArray categories = new JSONArray();

        OntClass ontClass = m.getOntClass(NS + className);
        //System.out.printf(ontClass.getLocalName().toString());
        for(Iterator instances = ontClass.listInstances(); instances.hasNext(); ) {
            Individual individual = (Individual) instances.next();
            //System.out.println(individual.toString().split("#")[1]);

            JSONObject node = new JSONObject(true);
            JSONObject link = new JSONObject(true);

            node.put("id", individual.toString().split("#")[1]);
            node.put("category", 1);
            node.put("name", individual.toString().split("#")[1]);
            node.put("label", individual.toString().split("#")[1].split("@")[0]);
            node.put("symbolSize", 20);

            link.put("source", ontClass.getLocalName().toString());
            link.put("target", individual.toString().split("#")[1]);
            link.put("label", "");

            nodes.add(node);
            links.add(link);

        }

        List<String> list = new ArrayList<>(Arrays.asList("概念", "实例", "数据属性"));
        list.stream().forEach(item->{
            JSONObject category = new JSONObject();
            category.put("name",item);
            categories.add(category);
        });

        nodes.addAll(NODE);
        links.addAll(LINK);

        dataJSon.put("categories",categories);
        dataJSon.put("nodes",nodes);
        dataJSon.put("links",links);

        writeToJson(nodesPath, nodes);
        writeToJson(linksPath, links);

        return dataJSon;
    }


    @RequestMapping("/getInstanceDetailByID")
    @ResponseBody
    public static JSONObject getInstanceDetailByID (String id) throws IOException {
        JSONArray NODE = new JSONArray();
        JSONArray LINK = new JSONArray();

        listClass.getJSONArray("nodes").stream().forEach(item->{
            NODE.add(item);
        });
        listClass.getJSONArray("links").stream().forEach(item->{
            LINK.add(item);
        });

        m.read(owlPath);
//        listClass();
        Individual individual = m.getIndividual(NS + id);
        JSONObject dataJSon = new JSONObject(true);
        JSONArray categories = new JSONArray();
        JSONArray nodes = new JSONArray();
        JSONArray links = new JSONArray();

        StmtIterator stmtIterator = individual.listProperties();
        JSONObject instanceNode = new JSONObject(true);
        JSONObject instanceLink = new JSONObject(true);

        // Why use individual.getLocalName is null
        instanceNode.put("id", individual.toString().split("#")[1]);
        instanceNode.put("category", 1);
        instanceNode.put("name", individual.toString().split("#")[1]);
        instanceNode.put("label", individual.toString().split("#")[1].split("@")[0]);
        instanceNode.put("symbolSize", 20);

        instanceLink.put("source", individual.getOntClass().toString().split("#")[1]);
        instanceLink.put("target", instanceNode.getString("id"));
        instanceLink.put("label", "Instance Of");

        nodes.add(instanceNode);
        links.add(instanceLink);

        while (stmtIterator.hasNext()){
            JSONObject node = new JSONObject(true);
            JSONObject link = new JSONObject(true);
            Statement statement = stmtIterator.nextStatement();

            // why get the AddressOP, HumanDP
            if(!statement.getPredicate().getLocalName().equals("AddressOP") && !statement.getPredicate().getLocalName().equals("AddressDP")) {
                //System.out.println(statement);
                if(statement.getObject().isLiteral()) {
                    node.put("id", UUID.randomUUID().toString().replace("-", ""));
                    node.put("category", 2);
                    node.put("name", statement.getObject().asLiteral().getValue().toString());
                    node.put("label", statement.getObject().asLiteral().getValue().toString());
                    node.put("symbolSize", 15);

                    link.put("source", individual.toString().split("#")[1]);
                    link.put("target", node.getString("id"));
                    link.put("label", statement.getPredicate().getLocalName());
                } else if(statement.getObject().isURIResource() && !statement.getPredicate().toString().split("#")[0].equals(rdf)){

                    JSONObject objectLink = new JSONObject(true);

                    /**
                     * Link to current individual
                     */
                    node.put("id", UUID.randomUUID().toString().replace("-", ""));
                    node.put("category", 1);
                    node.put("name", statement.getObject().asResource().toString().split("#")[1]);
                    node.put("label", statement.getObject().asResource().toString().split("#")[1]);
                    node.put("symbolSize", 20);

                    link.put("source", individual.toString().split("#")[1]);
                    link.put("target", node.getString("id"));
                    link.put("label", statement.getPredicate().getLocalName());


                    // why get NamedIndividual instead of Province
                    String n = statement.getObject().asResource().toString().split("#")[1];
                    Individual ind = m.getIndividual(NS + n);
                    System.out.println(ind.getOntClass().toString().split("#")[1]);

                    /**
                     *  Link to Class
                     */
                    objectLink.put("source", ind.getOntClass().toString().split("#")[1]);
                    objectLink.put("target", node.getString("id"));
                    objectLink.put("label", "Instance Of");
                    links.add(objectLink);
                } else {
                    node = null;
                    link = null;
                }
                if(node != null) {
                    nodes.add(node);
                }
                if(link != null) {
                    links.add(link);
                }
            }

        }

        nodes.addAll(NODE);
        links.addAll(LINK);

        List<String> list = new ArrayList<>(Arrays.asList("概念", "实例", "数据属性"));
        list.stream().forEach(item->{
            JSONObject category = new JSONObject();
            category.put("name",item);
            categories.add(category);
        });

        dataJSon.put("categories",categories);
        dataJSon.put("nodes",nodes);
        dataJSon.put("links",links);

        writeToJson(nodesPath, nodes);
        writeToJson(linksPath, links);

        return dataJSon;
    }

    //Save as JSON file
    public static void writeToJson(String filePath,JSONArray object) throws IOException
    {
        File file = new File(filePath);
        char [] stack = new char[1024];
        int top=-1;
        String string = object.toString();
        StringBuffer sb = new StringBuffer();
        char [] charArray = string.toCharArray();
        for(int i=0;i<charArray.length;i++){
            char c= charArray[i];
            if ('{' == c || '[' == c) {
                stack[++top] = c;
                sb.append("\n"+charArray[i] + "\n");
                for (int j = 0; j <= top; j++) {
                    sb.append("\t");
                }
                continue;
            }
            if ((i + 1) <= (charArray.length - 1)) {
                char d = charArray[i+1];
                if ('}' == d || ']' == d) {
                    top--;
                    sb.append(charArray[i] + "\n");
                    for (int j = 0; j <= top; j++) {
                        sb.append("\t");
                    }
                    continue;
                }
            }
            if (',' == c) {
                sb.append(charArray[i] + "");
                for (int j = 0; j <= top; j++) {
                    sb.append("");
                }
                continue;
            }
            sb.append(c);
        }
        Writer write = new FileWriter(file);
        write.write(sb.toString());
        write.flush();
        write.close();
    }

}
