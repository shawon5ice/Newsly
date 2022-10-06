import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsly/core/widgets/pager_swiper.dart';
import 'package:newsly/core/widgets/shimmer_loader_view.dart';
import 'package:newsly/details/presentation/ui/news_details.dart';
import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/presentation/bloc/home_bloc.dart';
import 'package:newsly/home/presentation/bloc/home_event.dart';
import 'package:newsly/home/presentation/bloc/home_state.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../../core/widgets/pager_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with  TickerProviderStateMixin{
  late TabController _tabController;
  late HomeBloc _homeBloc;
  var currentPage = 1;
  var lastPage = 3;
  String dropdownvalue = 'popularity';
  int? selectedTabIndex = 0;
  ScrollPhysics ScrollPhysicsSetting = ClampingScrollPhysics();


  // List of items in our dropdown menu
  var items = [
    'popularity',
    'relevancy',
    'publishedAt',
  ];

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const FetchNewsEventFixedNumber(1));
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_setActiveTabIndex);
    _homeBloc.stream.listen((state) {

    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPageNumber = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsly app"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0.r),
                  border: Border.all(
                    color: Colors.deepPurple,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(6.0.r),
                  ),
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        'All News',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        'Trending',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 509.h,
                child: TabBarView(
                    physics: ScrollPhysicsSetting,
                  children: [
                    _allNews(selectedPageNumber),
                    TrendingNews(),
                  ],
                  controller: _tabController,
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
    );
  }

  Widget TrendingNews(){
    return Container(
      height: 510.h,
      child: Column(
        children: [

          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is FetchTrendingNewsStateSuccess) {
              var articles = state.articles;
              return Expanded(
                child: PagerSwiper<Articles>(
                  items: state.articles,
                  onHideFab: (hide) {

                  },
                  itemBuilder: (context, item) => Card(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0.r),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(item.urlToImage.toString(),width: 300.w,height: 200.h,)
                          ),

                        ],
                      ),
                    ),
                  ),
                  isLoading: _homeBloc.isLoadingMoreVisible,
                  onNewLoad: (data, nextPage) {
                    setState(() {
                      _homeBloc.isLoadingMoreVisible = true;
                    });
                    _homeBloc.add(FetchTrendingNewsEvent(
                        nextPage,articles));
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
      child: Container(
        height: 510.h,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<String>(
                  value: dropdownvalue,
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
                      dropdownvalue = newValue!;
                      _homeBloc.sortBy = dropdownvalue;
                      _homeBloc.add(FetchNewsEventFixedNumber(1));
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
                if(!(lastPage<=100)){
                  lastPage = 100;
                }
                var articles = state.articles;
                return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewsDetails()));
                          },
                          child: Card(
                            margin: const EdgeInsets.all(5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Image.network(
                                    articles[index].urlToImage.toString().replaceAll("h_675,pg_1,q_80,w_1200", "h_80,pg_1,q_50,w_140"),
                                    width: 160,
                                    height: 80,
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child: Column(children: [
                                      Text(
                                        maxLines:2,
                                        overflow: TextOverflow.ellipsis,
                                        articles[index].title.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                      Text(articles[index].content!,
                                          maxLines:3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle()),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.articles.length,
                    ));
              }
              return const Expanded(child: ShimmerLoaderView(true));
            }),
            Container(
              width: double.infinity,
              color: Colors.white,
              height: 55,
              child: NumberPagination(
                controlButton: const Card(
                  elevation: 5,
                  color: Colors.white,
                ),
                threshold: 4,
                onPageChanged: (int pageNumber) {
                  //do somthing for selected page
                  setState(() {
                    selectedPageNumber = pageNumber;
                    _homeBloc.add(FetchNewsEventFixedNumber(selectedPageNumber));
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
      selectedTabIndex = _tabController?.index;
    });
    if(selectedTabIndex==1){
      ScrollPhysicsSetting = NeverScrollableScrollPhysics();
      _homeBloc.add(FetchTrendingNewsEvent(1,[]));
    }else{
      ScrollPhysicsSetting = ClampingScrollPhysics();
    }
  }
}
