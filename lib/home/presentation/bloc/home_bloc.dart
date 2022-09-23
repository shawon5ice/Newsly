import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/domain/repository/news_repository.dart';
import 'package:newsly/home/domain/usecase/fetch_news_usecase.dart';

import '../../../core/di/app_component.dart';
import '../../../core/session/session_manager.dart';
import 'package:bloc/bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool isLoadingMoreVisible = false;
  List<Articles>? articles = [];
  var session = locator<SessionManager>();

  HomeBloc() : super(HomeInitial()) {
    var session = locator<SessionManager>();
    on<FetchNewsEvent>(_onFetchNews);
  }

  _onFetchNews(FetchNewsEvent event, Emitter<HomeState> emit) async {
    if(event.nextPageIndex==1){
      emit(FirstPageLoading());
    }
    emit(FetchNewsLoading());
    FetchNewsUseCase newsUseCase =
    FetchNewsUseCase(locator<HomeRepository>());
    print('Page NO: ${event.nextPageIndex}');
    var response = await newsUseCase.fetchNews(params : {
      "PageNo": event.nextPageIndex,
    },);

    isLoadingMoreVisible = false;
    if (response != null && response.status == "ok") {
      articles = response.data!.articles;
    }
    if (articles!=null && articles!.isNotEmpty) {
      List<Articles>? updatedList = [];
      if (event.nextPageIndex > 1 && event.existingList.isNotEmpty) {
        updatedList = event.existingList + response!.data!.articles!;
      }
      emit(FetchNewsSuccess(event.nextPageIndex > 1 ? updatedList : response!.data!.articles!,response!.data!.totalResults!));
    } else {
      emit(const FetchNewsFailed('No jobs found'));
    }
  }
}
