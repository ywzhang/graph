<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="/js/jquery-3.3.1.js"></script>

    <script src="/js/echarts.js"></script>
    <script src="/js/echarts-gl.js"></script>
    <script src="/js/dataTool.js"></script>
</head>
<body>
<div id="container" style="width: 100%;height: 700px;"></div>
</body>
<script>
    var myChart = echarts.init(document.getElementById('container'), 'macarons');

    // myChart.setOption({
    //     color: ["rgb(203,239,15)", "rgb(73,15,239)","rgb(239,231,15)","rgb(15,217,239)","rgb(30,15,239)","rgb(15,174,239)","rgb(116,239,15)","rgb(239,15,58)","rgb(15,239,174)","rgb(239,102,15)","rgb(239,15,15)","rgb(15,44,239)","rgb(239,145,15)","rgb(30,239,15)","rgb(239,188,15)","rgb(159,239,15)","rgb(159,15,239)","rgb(15,239,44)","rgb(15,239,87)","rgb(15,239,217)","rgb(203,15,239)","rgb(239,15,188)","rgb(239,15,102)","rgb(239,58,15)","rgb(239,15,145)","rgb(116,15,239)","rgb(15,131,239)","rgb(73,239,15)","rgb(15,239,131)","rgb(15,87,239)","rgb(239,15,231)"],
    //     tooltip : {//提示框，鼠标悬浮交互时的信息提示
    //         trigger: 'item',//数据触发类型
    //         formatter: function(params){//触发之后返回的参数，这个函数是关键
    //             if (params.data.category !=undefined) {//如果触发节点
    //                 return params.data.label;//返回标签
    //             }else {//如果触发边
    //                 if(params.data.label == undefined){
    //                     return "未知"
    //                 }else{
    //                     return params.data.label;
    //                 }
    //             }
    //         },
    //     },
    //     legend: [{
    //         x: 'left',//图例位置
    //         data: categories.map(function (a) {
    //             return a.name;
    //         })
    //     }],
    //     series: [{
    //         name: '人际关系网络图',
    //         type: 'graphGL',
    //         nodes: nodes,
    //         edges: edges,
    //         categories: categories.sort(function (a, b) { return a.name - b.name; }),
    //         itemStyle: {
    //             normal: {
    //                 label: {
    //                     show: true,
    //                     textStyle: {
    //                         color: '#f00'
    //                     },
    //                     position: 'inside'
    //                 },
    //                 nodeStyle : {
    //                     brushType : 'both',
    //                     borderColor : 'rgba(255,215,0,0.4)',
    //                     borderWidth : 1
    //                 }
    //             }
    //         },
    //         // 关系边的公用线条样式
    //         lineStyle: {
    //             normal: {
    //                 show : true,
    //                 color: 'target',//决定边的颜色是与起点相同还是与终点相同
    //                 // curveness: 0.2//边的曲度，支持从 0 到 1 的值，值越大曲度越大。
    //             }
    //         },
    //         emphasis: {
    //             label: {
    //                 show: false
    //             },
    //             lineStyle: {
    //                 opacity: 0.5,
    //                 width: 4
    //             }
    //         },
    //         forceAtlas2: {
    //             steps: 1,//一次更新的迭代次数。
    //             stopThreshold: 2, //停止布局的阈值，当布局的全局速度因子小于这个阈值时停止布局。设为 0 则永远不停止。
    //             repulsionByDegree:true, //是否根据节点边的数量来计算节点的斥力因子，建议开启。
    //             linLogMode:false,//是否是lin-log模式。lin-log 模式会让聚类的节点更加紧凑
    //             jitterTolerence: 10,
    //             edgeWeight: [0.2, 1],//边的权重分布。映射自 links.value。
    //             gravity: 0,//节点受到的向心力。这个力会让节点像中心靠拢。
    //             edgeWeightInfluence: 1,//边权重的影响因子。值越大，则边权重对于引力的影响也越大。
    //             scaling: 0.5//布局的缩放因子，值越大则节点间的斥力越大。
    //         }
    //     }]
    // });

    // myChart.setOption({
    //     series: [{
    //         color : ['#EE6A50','#4F94CD','#B3EE3A','#DAA520','#f845f1', '#ad46f3','#5045f6','#4777f5','#44aff0','#45dbf7','#f6d54a','#ff4343','#fa827d','#3db18a','#ff5897','#372dc4','#c42d6d','#82c42d'],
    //         type: 'graphGL',
    //         nodes: graph.nodes,
    //         edges: graph.links,
    //         categories:graph.categories,
    //         modularity: {
    //             resolution: 2,
    //             sort: true
    //         },
    //         lineStyle: {
    //             color: '#f00',
    //             opacity: 0.05
    //         },
    //         itemStyle: {
    //             opacity: 1,
    //             // borderColor: '#fff',
    //             // borderWidth: 1
    //         },
    //         draggable: true,//指示节点是否可以拖动
    //         focusNodeAdjacency: true,
    //         // focusNodeAdjacencyOn: 'click',
    //         // symbolSize: function (value) {
    //         //     return Math.sqrt(value / 10);
    //         // },
    //         label: {
    //             textStyle: {
    //                 color: '#fff'
    //             }
    //         },
    //         emphasis: {
    //             label: {
    //                 show: true
    //             },
    //             lineStyle: {
    //                 opacity: 0.5,
    //                 width: 4
    //             }
    //         },
    //         forceAtlas2: {
    //             steps: 1,
    //             stopThreshold: 1,
    //             repulsionByDegree:true, //是否根据节点边的数量来计算节点的斥力因子，建议开启。
    //             jitterTolerence: 10,
    //             edgeWeight: [0.2, 1],
    //             gravity: 5,
    //             edgeWeightInfluence: 0,
    //         }
    //     }]
    // });


    $.get('/data/webkit-dep.json', function (webkitDep) {
        option = {
            series: [{
                color : ['#EE6A50','#4F94CD','#B3EE3A','#DAA520','#f845f1', '#ad46f3','#5045f6','#4777f5','#44aff0','#45dbf7','#f6d54a','#ff4343','#fa827d','#3db18a','#ff5897','#372dc4','#c42d6d','#82c42d'],
                type: 'graphGL',
                nodes: webkitDep.nodes,
                edges: webkitDep.links,
                categories:webkitDep.categories,
                modularity: {
                    resolution: 2,
                    sort: true
                },
                lineStyle: {
                    color: '#f00',
                    opacity: 0.05
                },
                itemStyle: {
                    opacity: 1,
                    // borderColor: '#fff',
                    // borderWidth: 1
                },
                draggable: true,//指示节点是否可以拖动
                focusNodeAdjacency: true,
                // focusNodeAdjacencyOn: 'click',
                // symbolSize: function (value) {
                //     return Math.sqrt(value / 10);
                // },
                label: {
                    textStyle: {
                        color: '#fff'
                    }
                },
                emphasis: {
                    label: {
                        show: true
                    },
                    lineStyle: {
                        opacity: 0.5,
                        width: 4
                    }
                },
                forceAtlas2: {
                    steps: 1,
                    stopThreshold: 1,
                    repulsionByDegree:true, //是否根据节点边的数量来计算节点的斥力因子，建议开启。
                    jitterTolerence: 10,
                    edgeWeight: [0.2, 1],
                    gravity: 5,
                    edgeWeightInfluence: 0,
                }
            }]
        };

        myChart.setOption(option);
    });
</script>
</html>