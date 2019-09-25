function getOption(graphInfo){
    title=graphInfo['title']
    nodes=graphInfo['nodes']
    links=graphInfo['links']
    categories=graphInfo['categories']

    var repulsion = 100;
    var isShow = false;

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
                }
            },
        },
        color : ['#EE6A50','#4F94CD','#B3EE3A','#DAA520','#f845f1', '#ad46f3','#5045f6','#4777f5','#44aff0','#45dbf7','#f6d54a','#ff4343','#fa827d','#3db18a','#ff5897','#372dc4','#c42d6d','#82c42d'],
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
                layout: 'none',
                draggable: false,//指示节点是否可以拖动
                focusNodeAdjacency: true, //当鼠标移动到节点上，突出显示节点以及节点的边和邻接节点
                roam: true,//是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 'scale' 或者 'move'。设置成 true 为都开启
                symbol: 'circle',
                // force : { //力引导图基本配置
                //     repulsion : repulsion,//节点之间的斥力因子。支持数组表达斥力范围，值越大斥力越大。
                //     // gravity : 0.03,//节点受到的向
                //     // // 中心的引力因子。该值越大节点越往中心点靠拢。
                //     // edgeLength :[10,50],//边的两个节点之间的距离，这个距离也会受 repulsion。[10, 50] 。值越小则长度越长
                //     layoutAnimation : false//因为力引导布局会在多次迭代后才会稳定，这个参数决定是否显示布局的迭代动画，在浏览器端节点数据较多（>100）的时候不建议关闭，布局过程会造成浏览器假死。
                // },
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
                // animationDuration: function (idx) {//初始动画的时长，支持回调函数
                //     // 越往后的数据延迟越大
                //     return idx * 200;
                // },
                animationEasing:"cubicIn",//初始动画的缓动效果
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
    myChart.setOption(option,true);
    //点击node实现缩放
    myChart.on('click', function (params) {
        if (params.seriesType === 'graph') {
            if (params.dataType === 'node') {
                cevent(params);
            }
        }
    });
    myChart.hideLoading();
}

function cevent(params) {
    var option = myChart.getOption();
    var nodesOption = option.series[0].nodes;
    var linksOption = option.series[0].links;
    var data = params.data;
    var linksNodes = [];

    if (!data.itemStyle) {
        /**
         判断所选节点的flag
         如果为真，则表示要展开数据,
         如果为假，则表示要折叠数据
         */
        if (data.flag) {
            for ( var m in linksOption) {
                if (linksOption[m].target == data.id) {
                    linksNodes.push(linksOption[m].source);
                }
            }
            if(linksNodes.length>0){
                if (linksNodes != null && linksNodes != undefined) {
                    for ( var p in linksNodes) {
                        nodesOption[linksNodes[p]].category = nodesOption[linksNodes[p]].category*-1;
                        nodesOption[linksNodes[p]].flag = true;
                    }
                    //背景虚化
                    for(var n in nodesOption){
                        // delete nodesOption[n]["itemStyle"];
                        if(linksNodes.indexOf(nodesOption[n].id)==-1 && nodesOption[n].id != data.id && nodesOption[n].category>=0){
                            nodesOption[n]["itemStyle"]={opacity :0.1};
                        }
                    }
                    for(var l in linksOption){
                        delete linksOption[l]["lineStyle"];
                        if(linksNodes.indexOf(linksOption[l].source)==-1){
                            linksOption[l]["lineStyle"]={opacity :0.02};
                        }
                    }
                }
                nodesOption[data.id].flag = false;
                //点击的节点到画布中心
                nodesOption[data.id].x = nodesOption[0].x;
                nodesOption[data.id].y = nodesOption[0].y;
                var width = $("#container").width();
                var height = $("#container").height();
                nodesOption[0].x = Math.random()*width;
                nodesOption[0].y = Math.random()*height;
                myChart.clear();
                myChart.setOption(option);
            }
        } else {
            /**
             遍历连接关系数组
             最终获得所选择节点的所有子孙子节点
             */
            for ( var m in linksOption) {
                //引用的连接关系的目标，既父节点是当前节点
                if (linksOption[m].target == data.id) {
                    linksNodes.push(linksOption[m].source);
                }
                //第一层子节点作为父节点，找到所有子孙节点
                if (linksNodes != null && linksNodes != undefined) {
                    for ( var n in linksNodes) {
                        if (linksOption[m].target == linksNodes[n]) {
                            linksNodes.push(linksOption[m].source);
                        }
                    }
                }
            }
            /**
             遍历最终生成的连接关系数组
             */
            if(linksNodes.length>0){
                if (linksNodes != null && linksNodes != undefined) {
                    for ( var p in linksNodes) {
                        if(nodesOption[linksNodes[p]].category>0){
                            nodesOption[linksNodes[p]].category = nodesOption[linksNodes[p]].category*-1;
                        }
                        nodesOption[linksNodes[p]].flag = true;
                    }
                    //去除背景虚化
                    for(var n in nodesOption){
                        delete nodesOption[n]["itemStyle"];
                    }
                    for(var l in linksOption){
                        delete linksOption[l]["lineStyle"];
                    }
                }
                //设置该节点的flag为true，下次点击展开子节点
                nodesOption[data.id].flag = true;
                //将中心节点还原
                nodesOption[data.id].x = nodesOption[0].x;
                nodesOption[data.id].y = nodesOption[0].y;
                var width = $("#container").width();
                var height = $("#container").height();
                nodesOption[0].x = width/2;
                nodesOption[0].y = height/2;

                myChart.clear();
                myChart.setOption(option);
            }
        }

    }
}
