<html>
<head>
    <meta charset="UTF-8">
    <title>知识图谱可视化</title>
    <script src="/js/jquery-3.3.1.js"></script>
    <script src="/js/echarts.js"></script>
    <script src="/js/drawl.js"></script>
    <script src="/js/layer-v3.1.1/layer/layer.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/layui.css" />
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 容器 -->
<div id="container" style="width: 80%;height: 100%;float: left;"></div>
<div style="width: 20%;height: 100%;float:right;">
    <div style="padding-top: 80%;">
        <button type="button" class="layui-btn layui-btn-normal" onclick="reset()">知识图谱</button>
    </div>
    <div style="margin-top: 30%;">
        <button type="button" class="layui-btn layui-btn-normal" onclick="relation()">概念关系</button>
    </div>
    <div style="margin-top: 30%;">
        <button type="button" class="layui-btn layui-btn-normal" onclick="detail()">详情信息</button>
    </div>
</div>
<script>

    function reset() {
        $.get('/data/mongo.json', function (webkitDep) {
            jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
            createGraph(myChart,jsondata);
        });
    }

    function relation() {
        $.get('/data/mongo.json', function (webkitDep) {
            var nodes = webkitDep.nodes;
            for(var i in nodes){
                nodes[i].itemStyle.color = "red";
            }
            jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
            createGraph(myChart,jsondata);
        });
    }

    function detail(){
        layer.prompt({title: '输入详情名称，并确认', formType: 0}, function(pass, index){
            var width = $("#container").width();
            var height = $("#container").height();

            var oldNodes  = option.series[0].nodes;
            var name = "";
            for(var i in oldNodes){
                if(oldNodes[i].label.indexOf(pass)==0){
                    name =  oldNodes[i].name;
                    break;
                }
            }

            //后续改为动态的
            if(name != ""){
                if(pass== "Person"){
                    $.get('/data/mongo-person.json', function (webkitDep) {
                        var nodes = webkitDep.nodes;
                        for(var i in nodes){
                            if(nodes[i].name == name && nodes[i].category<2){
                                nodes[i].x = width/2;
                                nodes[i].y = height/2;
                                nodes[i].fixed =true;
                            }
                        }
                        jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
                        createGraph(myChart,jsondata);
                    });
                }else if(pass== "Province"){
                    $.get('/data/mongo-province.json', function (webkitDep) {
                        var nodes = webkitDep.nodes;
                        for(var i in nodes){
                            if(nodes[i].name == name && nodes[i].category<2){
                                nodes[i].x = width/2;
                                nodes[i].y = height/2;
                                nodes[i].fixed =true;
                            }
                        }
                        jsondata={"categories":webkitDep.categories,"nodes":nodes,"links":webkitDep.links}
                        createGraph(myChart,jsondata);
                    });
                }else if(pass== "City"){
                    $.get('/data/mongo-city.json', function (webkitDep) {
                        var nodes = webkitDep.nodes;
                        for(var i in nodes){
                            if(nodes[i].name == name && nodes[i].category<2){
                                nodes[i].x = width/2;
                                nodes[i].y = height/2;
                                nodes[i].fixed =true;
                            }
                        }
                        jsondata={"categories":webkitDep.categories,"nodes":nodes,"links":webkitDep.links}
                        createGraph(myChart,jsondata);
                    });
                }else if(pass== "无锡市"){
                    $.get('/data/mongo-wuxi.json', function (webkitDep) {
                        var nodes = webkitDep.nodes;
                        for(var i in nodes){
                            if(nodes[i].name == name && nodes[i].category<2){
                                nodes[i].x = width/2;
                                nodes[i].y = height/2;
                                nodes[i].fixed =true;
                            }
                        }
                        jsondata={"categories":webkitDep.categories,"nodes":nodes,"links":webkitDep.links}
                        createGraph(myChart,jsondata);
                    });
                }else if(pass== "张三"){
                    $.get('/data/mongo-zs.json', function (webkitDep) {
                        var nodes = webkitDep.nodes;
                        for(var i in nodes){
                            if(nodes[i].name == name && nodes[i].category<2){
                                nodes[i].x = width/2;
                                nodes[i].y = height/2;
                                nodes[i].fixed =true;
                            }
                        }
                        jsondata={"categories":webkitDep.categories,"nodes":nodes,"links":webkitDep.links}
                        createGraph(myChart,jsondata);
                    });
                }
            }else{
                layer.msg("对不起，我没听懂，请再说一遍。")
            }
            layer.close(index);
        });
    }

    var myChart = echarts.init(document.getElementById('container'));
    myChart.showLoading();

    //创建数据
    $.get('/data/mongo.json', function (webkitDep) {
        jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
        createGraph(myChart,jsondata);
    });
</script>
</body>
</html>