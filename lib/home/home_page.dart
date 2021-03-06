import 'package:flutter/material.dart';
import 'package:wanandroid_ngu/home/banner.dart';
import 'package:wanandroid_ngu/http/common_service.dart';
import 'package:wanandroid_ngu/model/ArticleModel.dart';
import 'package:wanandroid_ngu/public_ui/webview_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>with AutomaticKeepAliveClientMixin{

  List<Article> _datas = new List();
  //listview控制器
  ScrollController _scrollController = ScrollController();
  int _page = 0;

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      //滑到了底部，加载更多
      if (_scrollController.position.pixels ==_scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }


  //获取文章列表数据
  Future<Null> getData() async {
    _page = 0;
    CommonService().getArticleList((ArticleModel _articleModel) {
      setState(() {
        _datas.clear();
        _datas.addAll(_articleModel.data.datas);
      });
    }, _page);
  }

  //加载更多的数据
  Future<Null> _getMore() async {
    _page++;
    CommonService().getArticleList((ArticleModel _articleModel) {
      setState(() {
        _datas.addAll(_articleModel.data.datas);
      });
    }, _page);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.separated(
            itemBuilder: _renderRow,
            physics: new AlwaysScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                color: Colors.black26,
              );
            },
            controller: _scrollController,
            //包含轮播图和加载更多
            itemCount: _datas.length + 2),
      ),
    );
  }


  Widget _renderRow(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        height: 200,
        color: Colors.green,
        child: new BannerWidget(),
      );
    }

    if (index  < _datas.length- 1) {
      return new InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            return new WebViewPage(title: _datas[index-1].title,url: _datas[index-1].link);
          }));
        },
        child: Column(
          children: <Widget>[
            Container(
              color:Colors.white,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: <Widget>[
                  Text(
                    _datas[index - 1].author,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      _datas[index - 1].niceDate,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color:Colors.white,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _datas[index - 1].title,
                      maxLines: 2,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,  color: const Color(0xFF3D4E5F),),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color:Colors.white,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _datas[index - 1].superChapterName,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return null;
  }

  /// 加载更多时显示的组件,给用户提示
//  Widget _getMoreWidget() {
//    return Container(
//      padding: EdgeInsets.all(16),
//      alignment: Alignment.center,
//      child: SizedBox(
//        width: 24,
//        height: 24,
//        child: CircularProgressIndicator(strokeWidth: 2,),
//      ),
//    );
//  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}


