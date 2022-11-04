import 'package:equatable/equatable.dart';
import 'package:newsly/home/data/model/news_response.dart';

// part 'news_details_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class FetchNewsEvent extends SearchEvent {
  // final int nextPageIndex;
  final String queryText;
  // final List<Articles> existingList;
  const FetchNewsEvent(this.queryText);
  @override
  List<Object?> get props => [];
}

class FetchNewsEventFixedNumber extends SearchEvent {
  final int pageNo;
  const FetchNewsEventFixedNumber(this.pageNo);
  @override
  List<Object?> get props => [];
}
class FetchTrendingNewsEvent extends SearchEvent {
  final int nextPageIndex;
  final List<Articles> existingList;
  const FetchTrendingNewsEvent(this.nextPageIndex,this.existingList);
  @override
  List<Object?> get props => [];
}
