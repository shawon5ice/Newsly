import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsly/core/routes/route.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';
import 'package:newsly/core/widgets/navigation_drawer.dart';
import 'package:newsly/core/widgets/pager_swiper.dart';
import 'package:newsly/core/widgets/shimmer_loader_view.dart';
import 'package:newsly/details/data/model/news_details_model.dart';
import 'package:newsly/details/presentation/ui/news_details.dart';
import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/presentation/bloc/home_bloc.dart';
import 'package:newsly/home/presentation/bloc/home_event.dart';
import 'package:newsly/home/presentation/bloc/home_state.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late HomeBloc _homeBloc;
  var currentPage = 1;
  var lastPage = 3;
  String dropDownValue = 'publishedAt';
  int? selectedTabIndex = 0;
  ScrollPhysics scrollPhysicsSetting = const ClampingScrollPhysics();

  // List of items in our dropdown menu
  var items = [
    'popularity',
    'relevancy',
    'publishedAt',
  ];

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_homeBloc.articles!.isEmpty){
      _homeBloc.add(const FetchNewsEventFixedNumber(1));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPageNumber = 1;
    return ThemeSwitchingArea(
      child: Scaffold(
        drawer: NavDraw(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Newsly",
            style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                  fontSize: 18.sp,
                  color: NewslyThemeData.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0.r),
                border: Border.all(
                  color: NewslyThemeData.primaryColor,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: NewslyThemeData.primaryColor,
                  borderRadius: BorderRadius.circular(6.0.r),
                ),
                unselectedLabelColor: NewslyThemeData.primaryColor,
                labelColor: Colors.white,
                tabs: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      'All News',
                      style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                      fontSize: 12.sp,
                          fontWeight: FontWeight.bold),
                      ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      'Trending',
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 520.h,
              child: TabBarView(
                physics: scrollPhysicsSetting,
                controller: _tabController,
                children: [
                  _allNews(selectedPageNumber),
                  trendingNews(),
                ],
              ),
            ),

            // TabBarView(
            //   controller: _tabController,
            //     children: [
            //   all_news(selectedPageNumber),
            //   TrendingNews(),
            // ]),
          ]),
        ),
      ),
    );
  }

  Widget trendingNews() {
    return SizedBox(
      height: 510.h,
      child: Column(
        children: [
          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is FetchTrendingNewsStateSuccess) {
              var articles = state.articles;
              return Expanded(
                child: PagerSwiper<Articles>(
                  items: state.articles,
                  onHideFab: (hide) {},
                  itemBuilder: (context, item) {
                    final span=TextSpan(text:item.title.toString(),style: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 24,
                        color: Color(0xff333242),
                        fontWeight: FontWeight.w900,
                        overflow: TextOverflow.ellipsis
                    ),);
                    final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr,);
                    tp.layout(maxWidth: 260); // equals the parent screen width
                    double extraSpace = 0;
                    if(tp.computeLineMetrics().length<=3){
                      extraSpace = (3-tp.computeLineMetrics().length)*20.0;
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(newsDetails,
                            arguments: NewsDetails(
                                title: item.title,
                                description: item.description,
                                author: item.author,
                                publishedAt: item.publishedAt,
                                url: item.url,
                                urlToImage: item.urlToImage,
                                sourceName: item.source!.name,
                                content: item.content,
                            ));
                      },
                      child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                const SizedBox(height: 50),
                                Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  color: NewslyThemeData.primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(height: 150),
                                        Text(
                                          item.title.toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Avenir',
                                              fontSize: 20,
                                              color: Color(0xff333242),
                                              fontWeight: FontWeight.w900,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                          maxLines: 3,
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(height: 20+extraSpace,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Transform.translate(
                              offset: const Offset(45,-20,),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey,
                                  //     blurRadius: 10.0,
                                  //     spreadRadius: 5.0,
                                  //   )
                                  // ],
                                ),
                                child: ClipOval(
                                  // borderRadius: BorderRadius.circular(500),
                                  child: Hero(
                                    tag: item.publishedAt.toString(),
                                    child: Image.network(
                                      item.urlToImage.toString(), width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return const Text('Opps!!!');
                                        }
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    );
                  },
                  isLoading: _homeBloc.isLoadingMoreVisible,
                  onNewLoad: (data, nextPage) {
                    setState(() {
                      _homeBloc.isLoadingMoreVisible = true;
                    });
                    _homeBloc.add(FetchTrendingNewsEvent(nextPage, articles));
                  },
                  totalPage: state.totalPage,
                  totalSize: state.totalArticles,
                  itemPerPage: 10,
                ),
              );
            }
            return const Expanded(child: ShimmerTrendingLoaderView(true));
          }),
        ],
      ),
    );
  }

  _allNews(int selectedPageNumber) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 520.h,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<String>(
                  value: dropDownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownValue = newValue!;
                      _homeBloc.sortBy = dropDownValue;
                      selectedPageNumber = 1;
                      currentPage = 1;
                      _homeBloc.add(const FetchNewsEventFixedNumber(1));
                    });
                  },
                ),
              ),
            ),
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              if (state is FetchNewsStateFixedNumber) {
                lastPage = state.totalArticles % 10 != 0
                    ? ((state.totalArticles / 10) + 1).toInt()
                    : state.totalArticles ~/ 10;
                if (!(lastPage <= 100)) {
                  lastPage = 100;
                }
                var articles = _homeBloc.articles as List<Articles>;
                return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // if(articles[index].urlToImage!=null && !articles[index].urlToImage!.contains(".jpg") || !articles[index].urlToImage.toString().contains(".jpeg") || !articles[index].urlToImage!.contains(".png")){
                          //   return Container();
                          // }
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(newsDetails,
                                  arguments: NewsDetails(
                                      title: articles[index].title,
                                      description: articles[index].description,
                                      author: articles[index].author,
                                      publishedAt: articles[index].publishedAt,
                                      url: articles[index].url,
                                      urlToImage: articles[index].urlToImage,
                                      sourceName: articles[index].source!.name,
                                      content: articles[index].content
                                  ));
                            },
                            child: Card(
                              elevation: 10,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey,
                                  //     offset: Offset(0.0, 1.0), //(x,y)
                                  //     blurRadius: 5.0,
                                  //   ),
                                  // ],
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          color: NewslyThemeData.borderCornerColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                          color: NewslyThemeData.borderCornerColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.all(10),
                                      height: 120,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.0),
                                            child: Hero(
                                              tag: articles[index]
                                                  .urlToImage.toString(),
                                              child: Image.network(
                                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                  return const Text('Opps!!!');
                                                },
                                                articles[index]
                                                    .urlToImage
                                                    .toString()
                                                    .replaceAll(
                                                    "h_675,pg_1,q_80,w_1200",
                                                    "h_100,pg_1,q_50,w_100"),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  articles[index].title.toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Transform.rotate(
                                                      angle: 45,
                                                      child: Icon(Icons.link),
                                                    ),
                                                    Text(articles[index]
                                                        .publishedAt
                                                        .toString())
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: NewslyThemeData.borderCornerColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))
                                        ),
                                        width: 10,
                                        height: 50,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: NewslyThemeData.borderCornerColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))
                                        ),
                                        width: 50,
                                        height: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: state.articles.length,
                      ),
                    ));
              }
              return const Expanded(child: ShimmerLoaderView(true));
            }),
            Container(
              width: double.infinity,
              height: 55,
              child: NumberPagination(
                controlButton: const Card(
                  elevation: 5,
                  color: Colors.white,
                ),
                threshold: 5,
                onPageChanged: (int pageNumber) {
                  //do somthing for selected page
                  setState(() {
                    selectedPageNumber = pageNumber;
                    _homeBloc
                        .add(FetchNewsEventFixedNumber(selectedPageNumber));
                  });
                },
                pageTotal: lastPage,
                pageInit: selectedPageNumber,
                // picked number when init page
                colorPrimary: Colors.deepPurple,
                colorSub: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setActiveTabIndex() {
    setState(() {
      selectedTabIndex = _tabController.index;
    });
    if (selectedTabIndex == 1) {
      scrollPhysicsSetting = const NeverScrollableScrollPhysics();
      _homeBloc.add(const FetchTrendingNewsEvent(1, []));
    } else {
      scrollPhysicsSetting = const ClampingScrollPhysics();
    }
  }

  Future<void> _pullRefresh() async {
    _homeBloc.add(const FetchNewsEventFixedNumber(1));
  }
}
