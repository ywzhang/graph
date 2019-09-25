<html>
<head>
    <meta charset="UTF-8">
    <title>知识图谱可视化</title>
    <script src="/js/jquery-3.3.1.js"></script>
    <script src="/js/echarts.js"></script>
    <script src="/js/drawl.js"></script>
    <#--animate 过度效果-->
    <link rel="stylesheet" href="https://unpkg.com/animate.css@3.5.2/animate.min.css">
    <script type="text/javascript" src="http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js"></script>

</head>
<body>
<style>
    .animated {
        -webkit-animation-duration: 1.5s;
        animation-duration: 1.5s;
        -webkit-animation-fill-mode: both;
        animation-fill-mode: both;
    }
</style>
<!-- 为 ECharts 准备一个具备大小（宽高）的 容器 -->
<div id="container" style="width: 70%;height: 800px;top: 50px;left: 10%;"></div>

<script>
    var myChart = echarts.init(document.getElementById('container'));
    myChart.showLoading();

    //创建数据
    // node id 主键id，category 类别分类，name 名称，lable tooltip显示的文字，symbolSize 节点大小 越大显示越大
    // links source 起始节点id，target 目的节点id，lable tooltip显示连接关系的文字
    // $.get('/data/mongo.json', function (webkitDep) {
    //     jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
    //     createGraph(myChart,jsondata);
    // });

    categories = [ {"name" : '学校'}, {"name" : '校区'}, {"name" : '学院'}, {"name" : '班级'} ];
    nodes =
        [{"id":0,"category":0,"name":'0',"label":'大学',"symbolSize":40,"flag":false},
        {"id":1,"category":1,"name":'1',"label":'校区1',"symbolSize":30,"flag":true},
        {"id":2,"category":-2,"name":'2',"label":'学院1',"symbolSize":20,"flag":true},
        {"id":3,"category":-2,"name":'3',"label":'学院2',"symbolSize":20,"flag":true},
        {"id":4,"category":1,"name":'4',"label":'校区2',"symbolSize":30,"flag":true},
        {"id":5,"category":-2,"name":'5',"label":'学院1',"symbolSize":20,"flag":true},
        {"id":6,"category":-2,"name":'6',"label":'学院2',"symbolSize":20,"flag":true},
        {"id":7,"category":-2,"name":'7',"label":'学院3',"symbolSize":20,"flag":true},
        {"id":8,"category":1,"name":'8',"label":'校区3',"symbolSize":30,"flag":true},
        {"id":9,"category":-2,"name":'9',"label":'学院1',"symbolSize":20,"flag":true},
        {"id":10,"category":-2,"name":'10',"label":'学院2',"symbolSize":20,"flag":true},
        {"id":11,"category":-2,"name":'11',"label":'学院3',"symbolSize":20,"flag":true},
        {"id":12,"category":-2,"name":'12',"label":'学院4',"symbolSize":20,"flag":true},
        {"id":13,"category":-3,"name":'13',"label":'一班',"symbolSize":10,"flag":true},
        {"id":14,"category":-3,"name":'14',"label":'二班',"symbolSize":10,"flag":true}
    ];
    links = [ {"source" : 1,"target" : 0}, {"source" : 4,"target" : 0}, {"source" : 8,"target" : 0},
        {"source" : 2,"target" : 1}, {"source" : 3,"target" : 1}, {"source" : 5,"target" : 4},
        {"source" : 6,"target" : 4}, {"source" : 7,"target" : 4}, {"source" : 9,"target" : 8},
        {"source" : 10,"target" : 8}, {"source" : 11,"target" : 8}, {"source" : 12,"target" : 8},
        {"source" : 13,"target" : 6}, {"source" : 14,"target" : 6} ];
    jsondata={"categories":categories,"nodes":nodes,"links":links}
    createGraph(myChart,jsondata);

</script>
</body>
</html>