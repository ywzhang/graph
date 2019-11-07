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
    <div style="padding-top: 40%;">
        <button type="button" style="width: 90px" class="layui-btn layui-btn-normal" onclick="reset()">知识图谱</button>
    </div>
    <div style="margin-top: 20%;">
        <button type="button" style="width: 90px" class="layui-btn layui-btn-normal" onclick="relation(this)">概念关系</button>
    </div>
    <div style="margin-top: 20%;">
        <button type="button" style="width: 90px" class="layui-btn layui-btn-normal" id="change" onclick="change(this)">全量图</button>
    </div>
    <div style="margin-top: 20%;">
        <button type="button" style="width: 90px" class="layui-btn layui-btn-normal" onclick="detail()">详情信息</button>
    </div>
    <div style="margin-top: 20%;">
        <button type="button" style="width: 90px" class="layui-btn layui-btn-normal" id="changeDetail" onclick="changeDetail(this)">详情图</button>
    </div>
    <input type="hidden" name="passname" value="">
    <input type="hidden" name="passnameDetail" value="">
</div>
<script>
    var width = $("#container").width();
    var height = $("#container").height();

    function reset() {
        $("#change").html("全量图");
        $("input[name=passname]").val("")
        $("#changeDetail").html("详情图");
        $("input[name=passnameDetail]").val("")
        createGraph(myChart,${dataJson});
    }

    //概念相关
    function relation(obj) {
        var value = $(obj).html();
        layer.prompt({title: '输入概念名称，并确认', formType: 0}, function(pass, index){
            $("input[name=passname]").val(pass)
            var data = exchange(value,pass);
            data["repulsion"]=500;
            data["gravity"]=0.001;
            if(!jQuery.isEmptyObject(data) && data.nodes.length >0){
                $("#change").html("全量图");
                $("#changeDetail").html("详情图");
                $("input[name=passnameDetail]").val("")
                createGraph(myChart,data);
            } else{
                layer.msg("对不起，我没听懂，请再说一遍。")
            }
            layer.close(index);
        });
    }

    function exchange(value,pass) {
        var data = {};
        var dataJson = ${dataJson};
        var nodes = dataJson["nodes"];
        var links = dataJson["links"];
        var NODES = [];
        var NODES2 = [];
        var LINKS2 = [];
        NODES.push(pass);
        //遍历2度节点
        for(var i in links){
            if(links[i].source == pass){
                NODES.push(links[i].target);
                LINKS2.push(links[i]);
            }
            if(links[i].target == pass){
                NODES.push(links[i].source);
                LINKS2.push(links[i]);
            }
        }
        //遍历3度节点
        for(var i in links){
            for(var j in NODES){
                if(links[i].source == NODES[j]){
                    if(NODES2.indexOf(links[i].target) == -1){
                        NODES2.push(links[i].target);
                        LINKS2.push(links[i]);
                    }
                }
                if(links[i].target == NODES[j]){
                    if(NODES2.indexOf(links[i].source) == -1){
                        NODES2.push(links[i].source);
                        LINKS2.push(links[i]);
                    }
                }
            }
        }
        var nodes2 = [];
        if(nodes.length>0) {
            for (var i in nodes) {
                if (NODES2.indexOf(nodes[i].id) != -1) {
                    if (pass == nodes[i].id) {
                        nodes[i].x = width / 2;
                        nodes[i].y = height / 2;
                        nodes[i].fixed = true;
                        nodes[i].symbolSize += 30;
                        nodes[i].label = {"fontSize": 12};
                        nodes2.push(nodes[i]);
                    } else if (NODES.indexOf(nodes[i].id) != -1) {
                        nodes[i].symbolSize += 15;
                        nodes[i].label = {"fontSize": 10};
                        nodes2.push(nodes[i]);
                    } else {
                        nodes2.push(nodes[i]);
                    }
                } else {
                    nodes[i].itemStyle = {"opacity": 0.5};
                }
            }

            if (value == "三度图" || value == "概念关系") {
                data = {"nodes": nodes2, "links": LINKS2, "categories": dataJson["categories"]};
            } else {
                data = dataJson;
            }
            return data;
        }
    }

    function change(obj) {
        var value = $(obj).html();
        var passname = $("input[name=passname]").val();
        var data = exchange(value,passname);
        if(passname!=""){
            if(value == "全量图"){
                $(obj).html("三度图");
            }else{
                data["repulsion"]=500;
                data["gravity"]=0.001;
                $(obj).html("全量图");
            }
            createGraph(myChart,data);
        }else{
            layer.msg("请先选择概念关系");
        }
    }

    //详情相关
    function detail(){
        layer.prompt({title: '输入详情名称，并确认', formType: 0}, function(pass, index){
            $("input[name=passnameDetail]").val(pass);
            var result = {};
            if(!jQuery.isEmptyObject(exchangeDetail(1,pass))){
                result = JSON.parse(exchangeDetail(1,pass));
            }
            if(!jQuery.isEmptyObject(result) && result.nodes.length>0){
                $("#change").html("全量图");
                $("#changeDetail").html("详情图");
                $("input[name=passname]").val("")
                createGraph(myChart, result);
            }else{
                layer.msg("对不起，我没听懂，请再说一遍。")
            }
            layer.close(index);
        });
    }

    function exchangeDetail(type,pass) {
        var data = {};
        var oldNodes  = option.series[0].nodes;
        var name = "";
        var category = 0;
        for(var i in oldNodes){
            if(oldNodes[i].remark.indexOf(pass)==0){
                name =  oldNodes[i].name;
                category = oldNodes[i].category;
                break;
            }
        }

        //后续改为动态的
        if(name != "") {
            if (category == 0) {
                $.ajax({
                    url: "/graph/getInstanceByClass",
                    data: {"className": name, "type": type},
                    dataType: "json",
                    async:false,
                    success: function (result) {
                        var nodes = result["nodes"];
                        for (var i in nodes) {
                            if (nodes[i].name == name && nodes[i].category < 2) {
                                nodes[i].x = width / 2;
                                nodes[i].y = height / 2;
                                nodes[i].fixed = true;
                            }
                        }
                        data = result;
                    }
                });
            } else {
                $.ajax({
                    url: "/graph/getInstanceDetailByID",
                    data: {"id": name, "type": type},
                    dataType: "json",
                    async:false,
                    success: function (result) {
                        var nodes = result["nodes"];
                        for (var i in nodes) {
                            if (nodes[i].name == name && nodes[i].category < 2) {
                                nodes[i].x = width / 2;
                                nodes[i].y = height / 2;
                                nodes[i].fixed = true;
                            }
                        }
                        data = result;
                    }
                });
            }
            return JSON.stringify(data);
        }
    }

    function changeDetail(obj) {
        var value = $(obj).html();
        var passnameDetail = $("input[name=passnameDetail]").val();
        if(passnameDetail!=""){
            if(value == "全量图"){
                var data = JSON.parse(exchangeDetail(1,passnameDetail));
                createGraph(myChart,data);
                $(obj).html("详情图");
            }else{
                var data = JSON.parse(exchangeDetail(0,passnameDetail));
                createGraph(myChart,data);
                $(obj).html("全量图");
            }
        }else{
            layer.msg("请先选择详情信息");
        }
    }

    var myChart = echarts.init(document.getElementById('container'));
    myChart.showLoading();

    //创建数据
    createGraph(myChart,${dataJson});
</script>
</body>
</html>