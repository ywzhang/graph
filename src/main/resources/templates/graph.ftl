<html>
<head>
    <meta charset="UTF-8">
    <title>知识图谱可视化</title>
    <script src="/js/jquery-3.3.1.js"></script>
    <script src="/js/echarts.js"></script>
    <script src="/js/drawl.js"></script>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 容器 -->
<div id="container" style="width: 70%;height: 600px;top: 50px;left: 10%;"></div>

<script>
    var myChart = echarts.init(document.getElementById('container'), 'macarons');
    myChart.showLoading();

    //创建数据
    //node id 主键id，category 类别分类，name 名称，lable tooltip显示的文字，symbolSize 节点大小 越大显示越大
    //links source 起始节点id，target 目的节点id，lable tooltip显示连接关系的文字
    var categories=[{name:"核心人物"},{name:"家人"},{name:"朋友"}]
    var nodes=[
        {id:1,name: '乔布斯',lable:'史蒂夫·乔布斯,美国发明家、企业家、美国苹果公司联合创办人。', symbolSize: 30},
        {id:2,category:1,name: '丽萨-乔布斯', lable:'史蒂夫·乔布斯的女儿',symbolSize: 20},
        {id:3,category:1,name: '保罗-乔布斯',lable:'史蒂夫·乔布斯的父亲', symbolSize: 20},
        {id:4,category:1,name: '克拉拉-乔布斯',lable:'史蒂夫·乔布斯的母亲', symbolSize: 20},
        {id:5,category:2,name: '劳伦-鲍威尔', symbolSize: 15},
        {id:6,category:2,name: '史蒂夫-沃兹尼艾克', lable:'苹果公司合伙人',symbolSize: 15},
        {id:7,category:2,name: '奥巴马', lable:'美国总统', symbolSize: 15},
        {id:8,category:2,name: '比尔-盖茨', lable:'比尔·盖茨,企业家、软件工程师、慈善家、微软公司创始人。',symbolSize: 15},
        {id:9,category:0,name: '乔纳森-艾夫',  symbolSize: 15},
        {id:10,category:0,name: '蒂姆-库克',lable:'蒂姆-库克,现任苹果公司首席执行官',symbolSize: 15},
        {id:11,category:0,name: '龙-韦恩',  symbolSize: 15}
    ];
    var links=[
        {source : '2', target : '1', lable: '女儿'},
        {source : '3', target : '2', lable: '父亲'},
        {source : '4', target : '1', lable: '母亲'},
        {source : '5', target : '1', },
        {source : '6', target : '1', lable: '合伙人'},
        {source : '7', target : '1'},
        {source : '8', target : '1',  lable: '竞争对手'},
        {source : '9', target : '1',  lable: '爱将'},
        {source : '10', target : '1'},
        {source : '11', target : '1'},
        {source : '5', target : '3'},
        {source : '7', target : '3'},
        {source : '7', target : '4'},
        {source : '7', target : '5'},
        {source : '7', target : '6'},
        {source : '8', target : '7'},
        {source : '8', target : '4'},
        {source : '10', target : '7'}
    ]
    jsondata={"title":"人物关系图","categories":categories,"nodes":nodes,"links":links}
    //数据格式为Json格式
    <#--var data = ${data};-->
    createGraph(myChart,jsondata);
</script>
</body>
</html>