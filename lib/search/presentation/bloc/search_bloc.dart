import 'package:newsly/core/logger/logger.dart';
import 'package:newsly/core/utils/constants.dart';
import 'package:newsly/search/data/model/news_response.dart';
import 'package:newsly/search/domain/repository/news_repository.dart';

import '../../../core/di/app_component.dart';
import '../../../core/session/session_manager.dart';
import 'package:bloc/bloc.dart';

import '../../domain/usecase/fetch_news_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  bool isLoadingMoreVisible = false;
  var lastPage;
  String sortBy = "publishedAt";
  List<Articles>? articles = [];
  var session = locator<SessionManager>();

  SearchBloc() : super(SearchInitial()) {
    var session = locator<SessionManager>();
    on<FetchNewsEvent>(_onFetchQueryNews);
  }

  _onFetchQueryNews(FetchNewsEvent event, Emitter<SearchState> emit) async {
    emit(FetchNewsLoading());
    FetchNewsUseCase newsUseCase =
    FetchNewsUseCase(locator<SearchRepository>());
    var response = await newsUseCase.fetchNews(params : {
      "apiKey":API_KEY,
      "q":event.queryText,
    },);

    isLoadingMoreVisible = false;
    if (response!=null) {
      // List<Articles>? updatedList = [];
      // if (event.nextPageIndex > 1 && event.existingList.isNotEmpty) {
      //   updatedList = event.existingList + response.data!.articles!;
      // }
      logger.printDebugLog(response.toString());
      emit(FetchNewsSuccess(response.data!.articles,response.data!.totalResults!));
    } else {
      emit(const FetchNewsFailed('No News found'));
    }
  }

}
