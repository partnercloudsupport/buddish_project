import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:buddish_project/constants.dart';
import 'package:buddish_project/data/model/news.dart';
import 'package:buddish_project/ui/common/no_content.dart';
import 'package:buddish_project/ui/news/news_container.dart';
import 'package:buddish_project/ui/news_compose/news_compose_screen.dart';
import 'package:buddish_project/ui/news_list/news_list_container.dart';
import 'package:buddish_project/utils/string_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NewsListScreen extends StatefulWidget {
  static final String route = '/newsList';

  final NewsListViewModel viewModel;

  NewsListScreen({
    this.viewModel,
  });

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

// ignore: mixin_inference_inconsistent_matching_classes
class _NewsListScreenState extends State<NewsListScreen> with AfterLayoutMixin<NewsListScreen>, SingleTickerProviderStateMixin {
  static GlobalKey<RefreshIndicatorState> _generalRefreshIndicatorKey;
  static GlobalKey<RefreshIndicatorState> _activityRefreshIndicatorKey;

  TabController _tabController;

  Widget _buildAppBar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: true,
      elevation: 1.0,
      forceElevated: true,
      title: Text(
        'ข่าวสาร',
        style: AppStyle.appbarTitle,
      ),
      bottom: TabBar(
        labelColor: AppColors.primary,
        controller: _tabController,
        tabs: [
          Tab(text: 'ข่าวสารทั่วไป'),
          Tab(text: 'นัดหมายกิจกรรม'),
        ],
      ),
      iconTheme: IconThemeData(color: AppColors.primary),
    );
  }

  void _showNewsCompose() {
    Navigator.of(context).pushNamed(NewsComposeScreen.route);
  }

  void _showNews(News news) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewsContainer(news: news)));
  }

  Widget _buildGeneralNews() {
    return RefreshIndicator(
      key: _generalRefreshIndicatorKey,
      onRefresh: () async {
        Completer<Null> completer = Completer();
        widget.viewModel.onRefresh(_activityRefreshIndicatorKey.currentState, completer);

        return completer.future;
      },
      child: widget.viewModel.generalNews.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.only(top: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final news = widget.viewModel.generalNews[index];

                        return NewsGeneralItem(
                          news: news,
                          onPressed: () => _showNews(news),
                        );
                      },
                      childCount: widget.viewModel.generalNews.length,
                    ),
                  ),
                )
              ],
            )
          : NoContent(
              title: 'ยังไม่มีข่าวสารในหมวดนี้',
              icon: FontAwesomeIcons.newspaper,
            ),
    );
  }

  Widget _buildActivityNews() {
    return RefreshIndicator(
      key: _activityRefreshIndicatorKey,
      onRefresh: () async {
        Completer<Null> completer = Completer();
        widget.viewModel.onRefresh(_activityRefreshIndicatorKey.currentState, completer);

        return completer.future;
      },
      child: widget.viewModel.activityNews.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.only(top: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final news = widget.viewModel.activityNews[index];

                        return NewsActivityItem(
                          news: news,
                          onPressed: () => _showNews(news),
                        );
                      },
                      childCount: widget.viewModel.activityNews.length,
                    ),
                  ),
                )
              ],
            )
          : NoContent(
              title: 'ยังไม่มีข่าวสารในหมวดนี้',
              icon: FontAwesomeIcons.newspaper,
            ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _generalRefreshIndicatorKey = new GlobalObjectKey<RefreshIndicatorState>('__general');
    _activityRefreshIndicatorKey = new GlobalObjectKey<RefreshIndicatorState>('__activity');

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: widget.viewModel.user.isAdmin
          ? FloatingActionButton(
              onPressed: _showNewsCompose,
              elevation: 1.0,
              child: Icon(
                Icons.add,
                color: AppColors.primary,
              ),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            _buildAppBar(),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildGeneralNews(),
            _buildActivityNews(),
          ],
        ),
      ),
    );
  }
}

class NewsActivityItem extends StatelessWidget {
  final News news;
  final VoidCallback onPressed;

  NewsActivityItem({
    this.news,
    this.onPressed,
  });

  Widget _buildDueDate() {
    final date = toThaiDate(news.dueDate);

    return Text(
      date,
      style: TextStyle(color: Colors.black54),
    );
  }

  Widget _buildLocation() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.pin_drop,
          color: Colors.black54,
        ),
        Flexible(
          child: Text(
            news.location,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    return Flexible(
      flex: 2,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: news.cover ?? 'https://increasify.com.au/wp-content/uploads/2016/08/default-image.png',
      ),
    );
  }

  Widget _buildDetail() {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDueDate(),
        Text(
          news.title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );

    final location = news.location != null ? _buildLocation() : Container();

    return Flexible(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: AppStyle.boxShadow),
        padding: EdgeInsets.all(Dimension.screenVerticalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            content,
            SizedBox(height: 4.0),
            location,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.grey.shade200,
//        height: 150.0,
        margin: EdgeInsets.only(bottom: Dimension.fieldVerticalMargin),
        child: Row(
          children: <Widget>[
            _buildDetail(),
            _buildThumbnail(),
          ],
        ),
      ),
    );
  }
}

class NewsGeneralItem extends StatelessWidget {
  final News news;
  final VoidCallback onPressed;

  NewsGeneralItem({
    this.news,
    this.onPressed,
  });

  Widget _buildImagePlaceholder(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 180.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildVideoTitle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            news.title,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCreated() {
    final formatter = DateFormat('dd MMM yyy');
    final date = formatter.format(news.dateCreated);

    return Text(
      date,
      style: TextStyle(color: Colors.black54),
    );
  }

  Widget _buildDiffDate() {
    return Text(
      news.diff,
      style: TextStyle(color: Colors.black54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDiffDate(),
            _buildVideoTitle(),
            SizedBox(height: 4.0),
            CachedNetworkImage(
              fit: BoxFit.cover,
              height: 200.0,
              width: 500.0,
              imageUrl: news.cover ?? 'https://increasify.com.au/wp-content/uploads/2016/08/default-image.png',
              placeholder: _buildImagePlaceholder(context),
            )
          ],
        ),
      ),
    );
  }
}
