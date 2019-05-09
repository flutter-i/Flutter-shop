import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'my_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  final List<BottomNavigationBarItem> bottomBar = [
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home),
        title: Text(
          "首页",
        )
      ),BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search),
        title: Text(
          "分类"
        )
      ),BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart),
        title: Text(
          "购物车"
        )
      ),BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: Text(
          "我的"
        )
      ),
  ];

  final List<Widget> pageList = [
      HomePage(),
      CategoryPage(),
      CartPage(),
      MyPage()
  ];

  //当前页面
  int currentIndex = 0;

  //当前页面
  var currentPage;

  @override
  void initState() {
    currentPage = pageList[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244,245,245,1.0),
      body: IndexedStack(
        children: pageList,
        index: currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        fixedColor: Colors.pink,
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = pageList[currentIndex];
          });
        },
      ),
    );
  }
}
