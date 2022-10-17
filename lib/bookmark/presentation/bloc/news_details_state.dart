// part of 'news_details_bloc.dart';


import 'package:equatable/equatable.dart';

abstract class NewsDetailsState extends Equatable {
  const NewsDetailsState();
}
//
class NewsDetailsInitial extends NewsDetailsState {
  @override
  List<Object> get props => [];
}
//
// class FetchNewsLoading extends HomeState {
//   @override
//   List<Object?> get props => [];
// }
//
// class PageChangeLoading extends HomeState {
//   @override
//   List<Object?> get props => [];
// }
// class TrendingNewsLoading extends HomeState {
//   @override
//   List<Object?> get props => [];
// }
// class FirstPageLoading extends HomeState {
//   @override
//   List<Object?> get props => [];
// }
//
// class FetchNewsFailed extends HomeState {
//   final String? message;
//
//   const FetchNewsFailed(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
//
// class FetchNewsSuccess extends HomeState {
//   final List<Articles> articles;
//   final int totalArticles;
//   const FetchNewsSuccess(this.articles,this.totalArticles);
//
//   @override
//   List<Object?> get props => [articles];
// }
//
// class FetchNewsStateFixedNumber extends HomeState {
//   final List<Articles> articles;
//   final int totalArticles;
//   const FetchNewsStateFixedNumber(this.articles,this.totalArticles);
//
//   @override
//   List<Object?> get props => [articles];
// }
//
//
// class FetchTrendingNewsStateSuccess extends HomeState {
//   final List<Articles> articles;
//   final int totalPage;
//   final int totalArticles;
//   const FetchTrendingNewsStateSuccess(this.articles,this.totalPage,this.totalArticles);
//
//   @override
//   List<Object?> get props => [articles];
// }
//
