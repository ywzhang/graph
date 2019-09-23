function getOption(graphInfo){
    title=graphInfo['title']
    nodes=graphInfo['nodes']
    links=graphInfo['links']
    categories=graphInfo['categories']

    var repulsion = 20;
    var isShow = false;
    var nodeSize = nodes.length;
    if(nodeSize<=50){
        isShow = true;
        repulsion = 300;
    }else if(50<nodeSize && nodeSize<=200){
        isShow = true;
        repulsion = 100;
    }else if(200<nodeSize && nodeSize<=400){
        isShow = true;
        repulsion = 50;
    }else if(400<nodeSize && nodeSize<=800){
        repulsion = 20;
    }else{
        repulsion = 10;
    }

    //设置option样式
    option = {
        title: {
            text: title,//标题
            top: 'top',//相对在y轴上的位置
            left: 'center'//相对在x轴上的位置
        },
        tooltip : {//提示框，鼠标悬浮交互时的信息提示
            trigger: 'item',//数据触发类型
            formatter: function(params){//触发之后返回的参数，这个函数是关键
                if(params.data!=undefined){
                    return params.data.label;//返回标签
                }
            },
        },
        color : ['#EE6A50','#4F94CD','#B3EE3A','#DAA520','#f845f1', '#ad46f3','#5045f6','#4777f5','#44aff0','#45dbf7','#f6d54a','#ff4343','#fa827d','#3db18a','#ff5897','#372dc4','#c42d6d','#82c42d'],
        //工具箱，每个图表最多仅有一个工具箱
        // toolbox: {
        //     show : true,
        //     feature : {//启用功能
        //         //dataView数据视图，打开数据视图，可设置更多属性,readOnly 默认数据视图为只读(即值为true)，可指定readOnly为false打开编辑功能
        //         dataView: {show: true, readOnly: true},
        //         restore : {show: true},//restore，还原，复位原始图表
        //         saveAsImage : {show: true},//saveAsImage，保存图片
        //     }
        // },
        legend: [{
            x: 'left',//图例位置
            data: categories.map(function (a) {
                return a.name;
            })
        }],
        series : [
            {
                name: '关系图',
                type: 'graph',
                layout: 'force',
                draggable: true,//指示节点是否可以拖动
                focusNodeAdjacency: true, //当鼠标移动到节点上，突出显示节点以及节点的边和邻接节点
                roam: true,//是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 'scale' 或者 'move'。设置成 true 为都开启
                symbol: 'circle',
                force : { //力引导图基本配置
                    repulsion : repulsion,//节点之间的斥力因子。支持数组表达斥力范围，值越大斥力越大。
                    // gravity : 0.03,//节点受到的向
                    // // 中心的引力因子。该值越大节点越往中心点靠拢。
                    // edgeLength :[10,50],//边的两个节点之间的距离，这个距离也会受 repulsion。[10, 50] 。值越小则长度越长
                    layoutAnimation : true//因为力引导布局会在多次迭代后才会稳定，这个参数决定是否显示布局的迭代动画，在浏览器端节点数据较多（>100）的时候不建议关闭，布局过程会造成浏览器假死。
                },
                itemStyle: {
                    normal: {
                        label: {
                            show: isShow,
                            textStyle: {
                                color: '#333'
                            },
                            position: 'inside'
                        },
                        nodeStyle : {
                            brushType : 'both',
                            borderColor : 'rgba(255,215,0,0.4)',
                            borderWidth : 1
                        }
                    }
                },
                // 关系边的公用线条样式
                lineStyle: {
                    normal: {
                        show : true,
                        color: 'target',//决定边的颜色是与起点相同还是与终点相同
                        // curveness: 0.2//边的曲度，支持从 0 到 1 的值，值越大曲度越大。
                    }
                },
                emphasis: {
                    lineStyle: {
                        width: 5
                    }
                },
                data: nodes,
                links:links,
                categories: categories
            }
        ]
    };
    return option
}

function createGraph(myChart,mygraph){
    //设置option样式
    option=getOption(mygraph)
    //使用Option填充图形
    myChart.setOption(option,true);
    //点击node实现缩放
    myChart.on('click', function (params) {
        if (params.seriesType === 'graph') {
            if (params.dataType === 'node') {
                var curnode = params.data;
                var container =  $("#container");
                container.stop().addClass('animated');
                container.stop().addClass('zoomIn');
                setTimeout(function(){
                    container.removeClass();
                },1600)

                if(curnode["hasenlarge"]){
                    $.get('/data/mongo.json', function (webkitDep) {
                        jsondata={"categories":webkitDep.categories,"nodes":webkitDep.nodes,"links":webkitDep.links}
                        myChart.clear();
                        option=getOption(jsondata)
                        myChart.setOption(option,true);
                    });
                }else{
                    var id = params.data.id;
                    var set = [];
                    var jsondata = {};
                    var nodes = [];
                    var links =[];
                    var categories =[];
                    set.push(id);
                    for(var i=0;i<mygraph.links.length;i++){
                        var link = mygraph.links[i];
                        if(link.target == id){
                            set.push(link.source);
                            links.push(link);
                        }
                    }
                    for(var i=0;i<mygraph.nodes.length;i++){
                        var node = mygraph.nodes[i];
                        var nid = node.id;
                        for(var j=0;j<set.length;j++){
                            if(set[j]==nid) {
                                if (id == nid) {
                                    node["hasenlarge"] = true;
                                }
                                nodes.push(node);
                            }
                        }
                    }
                    jsondata["title"]=mygraph.title;
                    jsondata["categories"]=mygraph.categories;
                    jsondata["nodes"]=nodes;
                    jsondata["links"]=links;
                    console.log(nodes)
                    myChart.clear();
                    option=getOption(jsondata)
                    myChart.setOption(option,true);
                }
            }
        }
    });
    myChart.hideLoading();
}

