import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../server/Api.dart';
import '../view/empty_view.dart';
import "dart:convert";
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  int page = 1;
  List<Map> hot = new List<Map>();

  @override
  void initState() {
    get();

    super.initState();
  }

  void get(){
    getHot({"page": page}).then((val){
      var data  = json.decode(val);
      setState(() {

        List<Map> datalist = (data['data'] as List).cast();
        hot.addAll(datalist);
      });
    });
  }

  Widget hotView(){
    return Column(
      children: <Widget>[
        hotTitle(),
        goods()
      ],
    );
  }

  Widget goods(){
    List<Widget> goodsView;
    goodsView = hot.map<Widget>((item){
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Image.network(item['image'],width: 200.0,),
              Text(
                item['name'],
                style: TextStyle(
                  color: Colors.pink
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        );
    }).toList();

    return Wrap(
      spacing: 2,
      children: goodsView,
    );
  }

  Widget hotTitle(){
    return Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text(
         "火爆专区",
        style: TextStyle(
          color: Colors.pink
        ),
      ),
    );
  }

  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("生活管家"),
        ),
        body: Center(
          child: FutureBuilder(
            future: getHomeData({
              "lon":115.02932,
              "lat":32.76189
            }),
            builder: (context,snap) {
              if(snap.hasData){
                var data = json.decode(snap.data);
                List<Map> list = (data["data"]['slides'] as List).cast();
                List<Map> category = (data["data"]['category'] as List).cast();
                String adBanner = data['data']['advertesPicture']['PICTURE_ADDRESS'];
                String image = data['data']['shopInfo']['leaderImage'];
                String phone = data['data']['shopInfo']['leaderPhone'];
                List<Map> recommendList = (data['data']['recommend'] as List).cast();
                return EasyRefresh(
                  key: _easyRefreshKey,
                  child: ListView(
                      children: <Widget>[
                        MySwiper(mImageList: list,),
                        MyNavigator(categoryList: category,),
                        MyAdBanner(adBanner: adBanner,),
                        callPhone(image, phone),
                        RecommendView(recommendList),
                        hotView()
                      ],
                  ),
                  loadMore: () async {
                    get();
                  },
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    loadText: "加载数据中",
                    noMoreText:"暂无数据",

                  )
                );
              }else{
                return EmptyView();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MySwiper extends StatelessWidget{

  List<Map> mImageList;

  MySwiper({this.mImageList});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 200.0,
      width: double.infinity,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network(mImageList[index]['image'],fit: BoxFit.fill,);
        },
        itemCount: mImageList.length,
        pagination: new SwiperPagination(),
        loop: true,
        autoplay: true,
      ),
    );
  }
}

class MyNavigator extends StatelessWidget{

  List<Map> categoryList;

  MyNavigator({this.categoryList});

  Widget toItem(context,item){
    return InkWell(
      onTap: (){print("点击了 $item");},
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Image.network(item['image'],width: 40.0,height: 40.0,),
            SizedBox(height: 5.0,),
            Text(
              item['mallCategoryName']
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(categoryList.length > 10){
      categoryList = categoryList.sublist(0,10);
    }

    return Container(
      child: GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(5.0),
        crossAxisCount: 5,
        children: categoryList.map<Widget>((item){
          return toItem(context,item);
        }).toList(),
      ),
    );
  }

}

class MyAdBanner extends StatelessWidget{

  String adBanner;

  MyAdBanner({this.adBanner});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Image.network(adBanner,),
    );
  }
}

class callPhone extends StatelessWidget{

  String url;
  String phone;

  callPhone(this.url, this.phone);

  //打电话
  _call() async {
    String phoneUrl = "tel: $phone";
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: InkWell(
        child: Image.network(url),
        onTap: _call,
      ),
    );
  }
}

class RecommendView extends StatelessWidget{

  List<Map> recommendList;


  RecommendView(this.recommendList);

  Widget _title(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: Colors.black12,
            width: 0.5
          )
        )
      ),
      child: Text(
        "商品推荐",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.pink
        ),
      ),
    );
  }

  Widget _hListView() {
    return Container(
      height: 200.0,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: recommendList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return _item(index);
        },
      ),
    );
  }

  Widget _item(int index) {
    Map map = recommendList[index];
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.5,
            color: Colors.black12
          )
        )
      ),
      child: InkWell(
        onTap: (){},
        child: Column(
          children: <Widget>[
            Image.network(map['image'],width: 120.0,height: 120.0,),
            SizedBox(height: 5.0,),
            Text(
              "￥${map["mallPrice"]}"
            ),
            Text(
                "￥${map["price"]}",
              style: TextStyle(
                color: Colors.black12,
                decoration: TextDecoration.lineThrough
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _title(),
          _hListView()
        ],
      ),
    );
  }





}


