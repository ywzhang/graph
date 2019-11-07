function getOption(graphInfo){
    title=graphInfo['title']
    nodes=graphInfo['nodes']
    links=graphInfo['links']
    categories=graphInfo['categories']
    color = ['#FFCC00','#9933FF','#B3EE3A']

    //设置option样式
    var option = {
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
                }else{
                    return params.data.label;//返回link
                }
            },
        },
        color : color,
        legend: [{
            selectedMode:false,
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
                draggable: false,//指示节点是否可以拖动
                focusNodeAdjacency: true, //当鼠标移动到节点上，突出显示节点以及节点的边和邻接节点
                roam: true,//是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 'scale' 或者 'move'。设置成 true 为都开启
                symbol: 'circle',
                force : { //力引导图基本配置
                    repulsion : [80,100],//节点之间的斥力因子。支持数组表达斥力范围，值越大斥力越大。
                    gravity : 0.05,//节点受到的向中心的引力因子。该值越大节点越往中心点靠拢
                    // edgeLength :[20,50],//边的两个节点之间的距离，这个距离也会受 repulsion。[10, 50] 。值越小则长度越长
                    layoutAnimation : true//因为力引导布局会在多次迭代后才会稳定，这个参数决定是否显示布局的迭代动画，在浏览器端节点数据较多（>100）的时候不建议关闭，布局过程会造成浏览器假死。
                },
                itemStyle: {
                    normal: {
                        label: {
                            show: true,
                            textStyle: {
                                color: '#333'
                            },
                            fontSize:8,
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
                        show : false,
                        color: '#4F94CD',//决定边的颜色是与起点相同还是与终点相同
                        // curveness: 0.2//边的曲度，支持从 0 到 1 的值，值越大曲度越大。
                    }
                },
                emphasis: {
                    lineStyle: {
                        width: 5
                    }
                },
                edgeSymbol: ['none', 'arrow'],
                edgeSymbolSize:5,
                nodes: nodes,
                links:links,
                categories: categories
            }
        ]
    };
    return option
}

function createGraph(myChart,mygraph){
    //设置option样式
    option=getOption(mygraph);
    //使用Option填充图形
    myChart.hideLoading();
    myChart.setOption(option,true);
}
