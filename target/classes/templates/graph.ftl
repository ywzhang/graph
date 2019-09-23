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
    //node id 主键id，category 类别分类，name 名称，lable tooltip显示的文字，symbolSize 节点大小 越大显示越大
    //links source 起始节点id，target 目的节点id，lable tooltip显示连接关系的文字
    $.get('/data/mongo.json', function (webkitDep) {
        jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
        createGraph(myChart,jsondata);
    });

</script>
</body>
</html>