import 'package:equatable/equatable.dart';
import 'package:newsly/home/data/model/news_response.dart';

// part 'news_details_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchNewsEvent extends HomeEvent {
  final int nextPageIndex;
  final List<Articles> existingList;
  const FetchNewsEvent(this.nextPageIndex,this.existingList);
  @override
  List<Object?> get props => [];
}

class FetchNewsEventFixedNumber extends HomeEvent {
  final int pageNo;
  const FetchNewsEventFixedNumber(this.pageNo);
  @override
  List<Object?> get props => [];
}
class FetchTrendingNewsEvent extends HomeEvent {
  final int nextPageIndex;
  final List<Articles> existingList;
  const FetchTrendingNewsEvent(this.nextPageIndex,this.existingList);
  @override
  List<Object?> get props => [];
}
