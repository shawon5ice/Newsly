// part of 'home_bloc.dart';


import 'package:equatable/equatable.dart';

import '../../data/model/news_response.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class FetchNewsLoading extends HomeState {
  @override
  List<Object?> get props => [];
}
class FirstPageLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class FetchNewsFailed extends HomeState {
  final String? message;

  const FetchNewsFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchNewsSuccess extends HomeState {
  final List<Articles> jobs;
  final int totalJobs;
  const FetchNewsSuccess(this.jobs,this.totalJobs);

  @override
  List<Object?> get props => [jobs];
}

