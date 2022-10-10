import 'package:newsly/core/logger/logger.dart';
import 'package:newsly/core/utils/constants.dart';
import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/domain/repository/news_repository.dart';
import 'package:newsly/home/domain/usecase/fetch_news_usecase.dart';

import '../../../core/di/app_component.dart';
import '../../../core/session/session_manager.dart';
import 'package:bloc/bloc.dart';

import 'news_details_event.dart';
import 'news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  bool isLoadingMoreVisible = false;
  var lastPage;
  String sortBy = "popularity";
  List<Articles>? articles = [];
  var session = locator<SessionManager>();

  NewsDetailsBloc() : super(NewsDetailsInitial()) {
    var session = locator<SessionManager>();
    // on<FetchNewsEvent>(_onFetchNews);
    // on<FetchNewsEventFixedNumber>(_onFetchNewsFixedPage);
    // on<FetchTrendingNewsEvent>(_onFetchTrendingNews);
  }
  //
  // _onFetchNews(FetchNewsEvent event, Emitter<HomeState> emit) async {
  //   if(event.nextPageIndex==1){
  //     emit(FirstPageLoading());
  //   }
  //   FetchNewsUseCase newsUseCase =
  //   FetchNewsUseCase(locator<HomeRepository>());
  //   print('Page NO: ${event.nextPageIndex}');
  //   var response = await newsUseCase.fetchNews(params : {
  //     "apiKey":API_KEY,
  //     "q":"apple",
  //     "page": event.nextPageIndex.toString(),
  //     "pageSize":10.toString(),
  //   },);
  //
  //   isLoadingMoreVisible = false;
  //   if (response!=null && response.data!.status =="ok") {
  //     List<Articles>? updatedList = [];
  //     if (event.nextPageIndex > 1 && event.existingList.isNotEmpty) {
  //       updatedList = event.existingList + response.data!.articles!;
  //     }
  //     logger.printDebugLog(updatedList.toString());
  //     emit(FetchNewsSuccess(event.nextPageIndex > 1 ? updatedList : response.data!.articles!,response.data!.totalResults!));
  //   } else {
  //     emit(const FetchNewsFailed('No jobs found'));
  //   }
  // }
  // _onFetchNewsFixedPage(FetchNewsEventFixedNumber event, Emitter<HomeState> emit) async {
  //   emit(PageChangeLoading());
  //   FetchNewsUseCase newsUseCase =
  //   FetchNewsUseCase(locator<HomeRepository>());
  //   print('Page NO: ${event.pageNo}');
  //   var response = await newsUseCase.fetchNews(params : {
  //     "apiKey":API_KEY,
  //     "q":"*",
  //     "page": event.pageNo.toString(),
  //     "pageSize":10.toString(),
  //     "sortBy":sortBy,
  //   },);
  //
  //   if (response!=null && response.data?.status =="ok") {
  //     int totalArticles = response.data!.totalResults!;
  //     emit(FetchNewsStateFixedNumber(response.data!.articles!, response.data!.totalResults!));
  //   } else {
  //     emit(const FetchNewsFailed('No jobs found'));
  //   }
  // }
  // _onFetchTrendingNews(FetchTrendingNewsEvent event, Emitter<HomeState> emit) async {
  //   if(event.nextPageIndex==1){
  //     emit(TrendingNewsLoading());
  //   }
  //   // emit(TrendingNewsLoading());
  //   FetchNewsUseCase newsUseCase =
  //   FetchNewsUseCase(locator<HomeRepository>());
  //   var response = await newsUseCase.fetchNews(params : {
  //     "apiKey":API_KEY,
  //     "q":"*",
  //     "page": event.nextPageIndex.toString(),
  //     "pageSize":10.toString(),
  //     "sortBy":sortBy,
  //   },);
  //
  //   isLoadingMoreVisible = false;
  //   if (response!=null && response.data!.status =="ok") {
  //     List<Articles>? updatedList = [];
  //     var totalPage = response.data!.totalResults! % 10 != 0
  //         ? ((response.data!.totalResults! / 10) + 1).toInt()
  //         : response.data!.totalResults! ~/ 10;
  //     if (event.nextPageIndex > 1 && event.existingList.isNotEmpty) {
  //       updatedList = event.existingList + response.data!.articles!;
  //     }
  //     logger.printDebugLog(updatedList.toString());
  //     emit(FetchTrendingNewsStateSuccess(event.nextPageIndex > 1 ? updatedList : response.data!.articles!,totalPage,response.data!.totalResults!));
  //   } else {
  //     emit(const FetchNewsFailed('No jobs found'));
  //   }
  // }
}
