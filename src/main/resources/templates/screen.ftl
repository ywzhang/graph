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
        createGraph(myChart,${dataJson});
    }

    function relation() {
        layer.prompt({title: '输入详情名称，并确认', formType: 0}, function(pass, index){
            layer.close(index);
        });
    }

    function detail(){
        layer.prompt({title: '输入详情名称，并确认', formType: 0}, function(pass, index){
            var width = $("#container").width();
            var height = $("#container").height();

            var oldNodes  = option.series[0].nodes;
            var name = "";
            var category = 0;
            for(var i in oldNodes){
                if(oldNodes[i].label.indexOf(pass)==0){
                    name =  oldNodes[i].name;
                    category = oldNodes[i].category;
                    break;
                }
            }

            //后续改为动态的
            if(name != ""){
                if(category == 0){
                    $.ajax({
                        url:"/graph/getInstanceByClass",
                        data:{"className":name},
                        dataType:"json",
                        success:function(result){
                            var nodes = result["nodes"];
                            for(var i in nodes){
                                if(nodes[i].name == name && nodes[i].category<2){
                                    nodes[i].x = width/2;
                                    nodes[i].y = height/2;
                                    nodes[i].fixed =true;
                                }
                            }
                            createGraph(myChart,result);
                        }
                    });
                }else{
                    console.log(name)
                    $.ajax({
                        url:"/graph/getInstanceDetailByID",
                        data:{"id":name},
                        dataType:"json",
                        success:function(result){
                            var nodes = result["nodes"];
                            for(var i in nodes){
                                if(nodes[i].name == name && nodes[i].category<2){
                                    nodes[i].x = width/2;
                                    nodes[i].y = height/2;
                                    nodes[i].fixed =true;
                                }
                            }
                            createGraph(myChart,result);
                        }
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
    createGraph(myChart,${dataJson});
</script>
</body>
</html>