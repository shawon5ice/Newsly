// part of 'news_details_bloc.dart';


import 'package:equatable/equatable.dart';

import '../../data/model/news_response.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class FetchNewsLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class PageChangeLoading extends SearchState {
  @override
  List<Object?> get props => [];
}
class TrendingNewsLoading extends SearchState {
  @override
  List<Object?> get props => [];
}
class FirstPageLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class FetchNewsFailed extends SearchState {
  final String? message;

  const FetchNewsFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchNewsSuccess extends SearchState {
  final List<Articles>? articles;
  final int totalSize;
  const FetchNewsSuccess(this.articles,this.totalSize);

  @override
  List<Object?> get props => [articles];
}

class FetchNewsStateFixedNumber extends SearchState {
  final List<Articles> articles;
  final int totalArticles;
  const FetchNewsStateFixedNumber(this.articles,this.totalArticles);

  @override
  List<Object?> get props => [articles];
}


class FetchTrendingNewsStateSuccess extends SearchState {
  final List<Articles> articles;
  final int totalPage;
  final int totalArticles;
  const FetchTrendingNewsStateSuccess(this.articles,this.totalPage,this.totalArticles);

  @override
  List<Object?> get props => [articles];
}

