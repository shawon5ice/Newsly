import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:newsly/core/core.dart';
import 'package:newsly/details/data/model/news_details_model.dart';
import 'package:newsly/home/home.dart';
import 'package:newsly/search/search.dart';
import 'package:number_pagination/number_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int selected = 1;
int lastPage = 5;
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late HomeBloc _homeBloc;
  var currentPage = 1;
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
    if (_homeBloc.articles!.isEmpty) {
      _homeBloc.add(const FetchNewsEventFixedNumber(1));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPageNumber = 1;
    return ThemeSwitchingArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: NavDraw(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Newsly",
            style: GoogleFonts.kaushanScript(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      PageTransition(child: BlocProvider(
                    create: (context) => SearchBloc(),
                    child: const SearchPage(),
                  ), type: PageTransitionType.rightToLeft));
                }, icon: const Icon(Icons.search))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              children: [
            Flexible(
              flex: 1,
              child: Container(
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'All News',
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Trending',
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
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
                    // final span = TextSpan(
                    //   text: item.title.toString(),
                    //   style: const TextStyle(
                    //       fontFamily: 'Avenir',
                    //       fontSize: 24,
                    //       color: NewslyThemeData.textColor,
                    //       fontWeight: FontWeight.w900,
                    //       overflow: TextOverflow.ellipsis),
                    // );
                    // final tp = TextPainter(
                    //   text: span,
                    //   maxLines: 3,
                    // );
                    // tp.layout(maxWidth: 260); // equals the parent screen width
                    // double extraSpace = 0;
                    // if (tp.computeLineMetrics().length <= 3) {
                    //   extraSpace = (3 - tp.computeLineMetrics().length) * 20.0;
                    // }
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
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 130),
                                      SizedBox(
                                        height: 140,
                                        child: Column(
                                          children: [
                                            Text(
                                              item.title.toString(),
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10,),
                                            Text("- ${item.author}",
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.access_time,
                                                  color: NewslyThemeData.primaryColor,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 5),
                                                Text("${DateFormat.yMMMd()
                                                    .format(DateTime.parse(item.publishedAt.toString()))} At ${DateFormat('hh:mm a')
                                                    .format(DateTime.parse(item.publishedAt.toString()))}",
                                                  style: GoogleFonts.ralewayDots(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: Offset(
                              0,
                              -100.h,
                            ),
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.transparent,
                                      blurRadius: 50.0,
                                      spreadRadius: 2.0,
                                    )
                                  ],
                                ),
                                child: ClipOval(
                                  // borderRadius: BorderRadius.circular(500),
                                  child: Hero(
                                    tag: item.publishedAt.toString(),
                                    child: CachedNetworkImage(
                                      imageUrl: item
                                          .urlToImage
                                          .toString()
                                          .replaceAll(
                                          "h_675,pg_1,q_80,w_200",
                                          "h_100,pg_1,q_50,w_200"),
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          SizedBox(height:200,width:200,child: Center(child: CircularProgressIndicator(value: downloadProgress.progress,color: NewslyThemeData.primaryColor,))),
                                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported,size: 100,),
                                    ),
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
            Align(
              alignment: Alignment.centerRight,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                              .of(context)
                              .hintColor,
                        ),
                      ),
                        barrierLabel: 'Sort By',
                      items: items
                          .map((item) =>
                          DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                          .toList(),
                      value: dropDownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValue = newValue!;
                            _homeBloc.sortBy = dropDownValue;
                            selectedPageNumber = 1;
                            currentPage = 1;
                            _homeBloc.add(const FetchNewsEventFixedNumber(1));
                          });
                        },
                      buttonHeight: 40,
                      buttonWidth: 120,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownPadding: null,
                    ),
                  ),
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
                                  content: articles[index].content));
                        },
                        child: Card(
                          elevation: 4,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Stack(
                              children: [
                                CornerWidget(horizontal: true),
                                CornerWidget(horizontal: false),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  height: 120,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Hero(
                                          tag: articles[index]
                                              .urlToImage
                                              .toString(),
                                          child: CachedNetworkImage(
                                            imageUrl: articles[index]
                                                .urlToImage
                                                .toString()
                                                .replaceAll(
                                                "h_675,pg_1,q_80,w_1200",
                                                "h_100,pg_1,q_50,w_100"),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                SizedBox(height:10,width:80,child: Center(child: LinearProgressIndicator(value: downloadProgress.progress,color: NewslyThemeData.primaryColor,))),
                                            errorWidget: (context, url, error) => const Icon(Icons.image_not_supported,size: 100,),
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
                                                style: GoogleFonts.raleway(
                                                  textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Icon(Icons.access_time ,size: 16,),
                                                const SizedBox(width: 5,),
                                                Text("${DateFormat.yMd()
                                                    .format(DateTime.parse(articles[index].publishedAt.toString()))} At ${DateFormat('HH:mm')
                                                        .format(DateTime.parse(articles[index].publishedAt.toString()))}",style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12),
                                                ),)
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
                                  child: CornerWidget(horizontal: false,)
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CornerWidget(horizontal: true,),)
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
            SizedBox(
              width: double.infinity,
              height: 55,
              child: NumberPagination(
                controlButton: const Card(
                  elevation: 0,
                  color: Colors.yellow,
                ),
                threshold: 5,
                onPageChanged: (int pageNumber) {
                  //do somthing for selected page
                  setState(() {
                    selectedPageNumber = pageNumber;
                    selected = pageNumber;
                    _homeBloc
                        .add(FetchNewsEventFixedNumber(selectedPageNumber));
                  });
                },
                pageTotal: lastPage,
                pageInit: selected,
                // picked number when init page
                colorPrimary: NewslyThemeData.primaryColor,
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
